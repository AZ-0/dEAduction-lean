import data.real.basic
import data.set
import tactic
open push_neg



namespace tactic.interactive
open lean.parser tactic interactive 
open interactive (loc.ns)
open interactive.types
open tactic expr
local postfix *:9001 := many -- sinon ne comprends pas ident*

/- décompose en premier caractère, reste  INUTILISE-/
def un_car : string → string × string
| ⟨(x :: xs)⟩  := ( ⟨ [x] ⟩ , ⟨ xs ⟩ )
| _ := ("","")

def deux_car : string → string
| ⟨(x ::  y :: xs)⟩  := ⟨ [x,y] ⟩ 
| _ := ""

def trois_car : string → string
| ⟨(x ::  y :: z ::xs)⟩  := ⟨ [x,y,z] ⟩ 
| _ := ""

/- décompose une chaine de caractères selon la première parenthèse ouvrante
Le premier terme ne sert qu'à la récursivité  INUTILISE-/
meta def debut_chaine : string × string → string × string
| (s , t ) := do
    let d := un_car t,
    match d  with
        | ("(",reste) :=  (s,t)
        | ( ⟨(x)⟩, reste) :=  (debut_chaine (s ++ d.1, reste )) 
        -- | _ := ("ERREUR", "")
        end

-- set_option trace.eqn_compiler.elim_match true
    
/- When e is a pi or lambda expr, instanciate e returns 
a local constant a that stands for the first bound variable,
and the body of a with the free variable replaced by a -/
meta def instanciate (e : expr) : tactic (expr × expr) :=
match e with
| (pi pp_name binder type body) := do 
    a ← mk_local' pp_name binder type,
    let inst_body := instantiate_var body a,
    return (a , inst_body)
| (lam pp_name binder type body) := do 
    a ← mk_local' pp_name binder type,
    let inst_body := instantiate_var body a,
    return (a , inst_body)
| _ := return (e, e)
end



/- Décompose la racine d'une expression (un seul pas) 
 LOGICS : ET, OU, SSI, QUELQUESOIT, IMPLIQUE, FONCTION, NON, EXISTE,
SETS: INTER, UNION, INCLUS, APPARTIENT, COMPLEMENTAIRE1,s IMAGE_ENSEMBLE, IMAGE_RECIPROQUE, 
EGALITE, ENSEMBLE1, APPLICATION
NUMBERS: -/
private meta def analyse_expr_step  (e : expr) : tactic (string × (list expr)) := 
do  S ←  (tactic.pp e), let e_joli := to_string S, 
match e with
| (lam name binder type body)          := return ("lambda[" ++ to_string name ++ "]", [type,body]) -- name → binder_info → expr → expr → expr
------------------------- LOGIQUE -------------------------
| `(%%p ∧ %%q) := return ("PROP_AND", [p,q])
| `(%%p ∨ %%q) := return ("PROP_OR", [p,q])
| `(%%p ↔ %%q) := return ("PROP_IFF", [p,q])
| `(¬ %%p) := return ("PROP_NOT", [p])
| `(%%p → false)  := return ("PROP_NOT", [p])
| (pi name binder type body) := do let is_arr := is_arrow e,
    if is_arr then do is_p ← tactic.is_prop e,
                    if is_p then return ("PROP_IMPLIES", [type,body])
                        else return ("FUNCTION", [type,body]) 
     else do (var_, inst_body) ← instanciate e,
               return ("QUANT_∀", [var_, type, inst_body]) 
| `(Exists %%p) := do match p with          --  améliorer : cas d'une prop, mais attention aux variables !!
    | (lam name binder type body) := 
    -- la suite teste s'il s'agit de l'existence d'un objet ou d'une propriété
        -- d'abord, si `body` contient des variables libres, c'est une propriété
        -- if type.has_var then return ("EXISTE[PROP:" ++ to_string name ++ "]", [type,body])
        -- si ce n'est pas le cas, on peut chercher son type, et voir si c'est Prop
        -- else do type_type ← infer_type type,
            -- if type_type = `(Prop) 
            do (var_, inst_body) ← instanciate p,
                is_p ← is_prop type, if is_p
                then return ("PROP_∃", [var_, type, inst_body])
                else return ("QUANT_∃", [var_, type, inst_body])
    |  _ := return ("ERROR", [])
    end 
------------------------- THEORIE DES ENSEMBLES -------------------------
| `(%%A ∩ %%B) := return ("SET_INTER", [A,B])
| `(%%A ∪ %%B) := return ("SET_UNION", [A,B])
| `(set.compl %%A) := return ("SET_COMPLEMENT", [A])
| `(%%A \ %%B) := return ("SET_SYM_DIFF", [A,B])
| `(%%A ⊆ %%B) := return ("PROP_INCLUDED", [A,B])
| `(%%a ∈ %%A) := return ("PROP_BELONGS", [a,A])
| `(@set.univ %%X) := return ("SET_UNIVERSE", [X])
| `(-%%A) := return ("MINUS", [A])   
| `(set.Union %%A) := return ("SET_UNION+", [A])
| `(set.Inter %%A) := return ("SET_INTER+", [A])
| `(%%f '' %%A) := return ("SET_IMAGE", [f,A])
| `(%%f  ⁻¹' %%A) := return ("SET_INVERSE", [f,A])
| `(∅) := return ("SET_EMPTY", [])
| `(_root_.set %%X) := return ("SET", [X])
-- polymorphe
| `(%%a = %%b) := return ("PROP_EQUAL", [a,b]) -- faudrait connaitre le type ?
| `(%%a ≠ %%b) := return ("PROP_EQUAL_NOT", [a,b]) -- faudrait connaitre le type ?
----------- TOPOLOGY --------------
-- | `(B(%%x, %%r))


---------------------------- NOMBRES particuliers (cf aussi plus bas) 
| `(0:ℝ) := return ("NUMBER[0]",[])               -- OK, mais peut-être faut-il garder l'info 0 : réel
| `(0:ℕ) := return ("NUMBER[0]",[])               -- non testé
| `(0:ℤ) := return ("NUMBER[0]",[])               -- non testé
| `(1:ℝ) := return ("NUMBER[1]",[])               
| `(1:ℕ) := return ("NUMBER[1]",[])               -- non testé
| `(1:ℤ) := return ("NUMBER[1]",[])               -- non testé
-- | `(0 < %%b) := return ("POSITIF", [b]) 
| `(%%a < %%b) := return ("PROP_<", [a,b]) 
| `(%%a ≤ %%b) := return ("PROP_≤", [a,b])
-- | `(%%a > 0) := return ("POSITIF", [a])
| `(%%a > %%b) := return ("PROP_>", [a,b]) 
| `(%%a ≥ %%b) := return ("PROP_≥", [a,b]) 
------------------------------ Meta_applications

| (app fonction argument)   := -- do let Sfonction := to_string(fonction),
    -- pour les nombres, utiliser la pretty printer de Lean
    -- récupérer le type ?
    if is_numeral e
        then return ("NUMBER["++e_joli ++"]",[]) 
    -- détecter les sous-ensembles
--    else if to_string(fonction) = "set.{0}"  
--        then return("SET", [argument])
--        else return("META_APPLICATION[[pp:" ++ e_joli ++"]]",[fonction,argument])
        else return("APPLICATION",[fonction,argument])
| `(ℝ) := return ("TYPE_NUMBER[ℝ]",[])
| `(ℕ) := return ("TYPE_NUMBER[ℕ]",[])
| (const name list_level)   := return ("CONSTANT[name:"++ e_joli ++ "/" ++ to_string name ++"]", []) -- name → list level → expr
| (var nat)       := return ("VAR["++ to_string nat ++ "]", []) --  nat → expr
| (sort level)      := return ("TYPE", [])  -- level → expr
| (mvar name pretty_name type)        := return ("METAVAR[" ++ to_string pretty_name ++ "]", []) -- name → name → expr → expr
| (local_const name pretty_name bi type) := return ("LOCAL_CONSTANT[name:"++ to_string pretty_name++"/identifier:"++ to_string name ++ "]", []) -- name → name → binder_info → expr → expr
| (elet name_var type_var expr body)        := return ("LET["++ to_string name_var ++"]", [type_var,expr,body]) --name → expr → expr → expr → expr
| (macro liste pas_compris)       := return ("MACRO", []) -- macro_def → list expr → expr
end

-- A node will be a leaf of the analysis tree iff it belongs to the following list:
-- leaves = ["NOMBRE", "CONSTANT", "VAR", "TYPE", "METAVAR", "LOCAL_CONSTANT", 
--          "LET", "MACRO", "ERREUR"]    
-- A leaf is followed by a separateur_virgule or a ")"
-- A node which is not a leaf is followed by a "("


def separateur_virgule := "¿, "
def separateur_egale := " ¿= "
def open_paren := "¿("
def closed_paren := "¿)"
/- Analyse récursivement une expression à l'aide de analyse_expr_step, 
renvoie le résultat sous forme de chaine bien parenthésée-/
private meta def analyse_rec : expr →  tactic string 
| e := 
do ⟨string, liste_expr⟩ ←  analyse_expr_step(e), 
--    bool ← is_prop e,
--    let string := to_string bool ++ "." ++ string,
    match liste_expr with
    -- ATTENTION, cas de plus de trois arguiments non traité
    -- à remplacer par un list.map
    |[e1] :=  do 
       string1 ← analyse_rec e1,
       return(string ++ open_paren ++ string1 ++ closed_paren)
    |[e1,e2] :=  do 
        string1 ← analyse_rec e1,
        string2 ← analyse_rec e2,
--        if  string = "APPLICATION"
--            then return (string1 ++ open_paren ++ string2 ++ closed_paren) else
        return (string ++ open_paren ++ string1 ++ separateur_virgule ++ string2 ++ closed_paren)
    |[e1,e2,e3] :=  do  -- non utilisé
        string1 ← analyse_rec e1,
        string2 ← analyse_rec e2,
        string3 ← analyse_rec e3,
        return (string ++ open_paren ++ string1 ++ separateur_virgule ++ string2 ++ separateur_virgule ++ string3 ++ closed_paren)
    | _ :=    return(string)
    end
private meta def analyse_expr : expr →  tactic string
| e := do
    expr_t ←  infer_type e,
    bool ← is_prop expr_t,
    -- expr_tt ← infer_type expr_t,
    if bool then do
            -- S ←  (tactic.pp expr_t), 
            -- let S1 := to_string S,
            S ←  (tactic.pp expr_t), let et_joli := to_string S, 
            S1b ← analyse_rec e,
            S2 ← analyse_rec expr_t,
            let S3 := "PROPERTY[" ++ S1b ++ "/pp_type: " ++ et_joli ++ "]" ++ separateur_egale ++ S2,
            return(S3)
        else  do
            -- let S1 :=  to_string e, 
            S1b ← analyse_rec e,
            S2 ← analyse_rec expr_t,
            let S3 := "OBJECT[" ++ S1b ++ separateur_egale ++ S2,
            return(S3)


/- Affiche la liste des objets du contexte, séparés par des retour chariots 
format :  "OBJET" ou "PROPRIETE" : affichage Lean : structure -/
meta def hypo_analysis : tactic unit :=
do liste_expr ← local_context,
    trace "context:",
    liste_expr.mmap (λ h, analyse_expr h >>= trace),
    return ()


/- Affiche la liste des buts, même format que analyse_contexte
(excepté qu'il n'y a que des PROPRIETES) -/ 
meta def goals_analysis : tactic unit :=
do liste_expr ← get_goals,
    trace "goals:", 
    liste_expr.mmap (λ h, analyse_expr h >>= trace),
    return ()



---------------------------------------------------------
--------- NON UTILISES (debuggage) ----------------------------------
---------------------------------------------------------


/- Appelle l'analyse récursive sur le but ou sur une hypothèse. Non utilisé par la suite. -/
meta def analysis (names : parse ident*) : tactic unit := 
match names with
    | [] := do goal ← tactic.target,
                trace (analyse_rec goal)
    | [nom] := do expr ← get_local nom,
                expr_t ←  infer_type expr,
                expr_tt ← infer_type expr_t,
                -- la suite différencie selon la sémantique, 
                -- ie les objets (éléments, ensembles, fonctions)
                -- vs les propriétés
                if expr_tt = `(Prop) then  
                    trace (analyse_rec expr_t)
                else  do S1 ← (analyse_rec expr), 
                        S2 ← (analyse_rec expr_t),
                        --let S2 := to_string expr_t,
                        let S3 := S1 ++ " : "++ S2,
                        trace(S3)
    | _ := skip
    end

/- Appelle l'analyse en 1 coup sur le but ou sur une hypothèse. Non utilisé par la suite. -/
meta def analysis1 (names : parse ident*) : tactic unit := 
match names with
    | [] := do goal ← tactic.target,
                trace (analyse_expr_step goal)
    | [nom] := do expr ← get_local nom,
                expr_t ←  infer_type expr,
                trace (analyse_expr_step expr_t)
    | _ := skip
    end

end tactic.interactive
