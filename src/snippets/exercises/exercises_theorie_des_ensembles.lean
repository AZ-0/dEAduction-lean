import data.set
import tactic

-- dEAduction imports
import logics
import definitions
import definitions_theorie_des_ensembles
import structures


local attribute [instance] classical.prop_decidable


--------------------------------
-- Commentaire deaduction:
-- le logiciel parse les sections (*todo*) et les définitions
-- on peut définir des liste (macros) dans des docstrings, syntaxe
-- @Macro
-- suivi du nom de la macro sur une ligne seule,
-- suive de la liste qui finit à la fin du docstring
-- The lemmas that will serve as exercises are tagged by @Exercise
-- followed by the title on a single line
-- followed by a text description preceded by @Description
-- followed by macros representing the list of active buttons in each window

-- pendant les exos qui suivent, le logiciel affichera en titre : 
-- Théorie des ensembles (1) Ensembles
-- Puis, plus loin,
-- Théorie des ensembles (2) Applications






/- 
@Macro
STANDARD_LOGIC
∀, ∃, →, ↔, ET, OU, NON, 
Absurde, Contraposée, Par cas, Choix
-/


-- CDD : les deux lignes qui suivent indiquent les boutons à intégrer dans les zones correspondantes
-- pour tous les exercices de la section
-- @Definitions theorie_des_ensembles
-- (inclure toutes les définitions de la section "théorie des ensemble",
-- i.e. celles dont le nom commence par "definitions.theorie_des_ensembles")
-- 

-----------------------------------------
-----------------------------------------
section unions_et_intersections  -- sous-section 1
-----------------------------------------
-----------------------------------------
namespace definitions.unions_et_intersections





variables {X : Type} {A B C : set X}

/- 
@Exercise
Intersection d'unions
@Description
L'intersection est distributive par rapport à l'union
@Macro
LOGIC
STANDARD_LOGIC +Contradiction -Choix
-- @Macro
-- DEFINITIONS
-- @Macro
-- THEOREM
@ExpectedVariables
2
-/
lemma union_distributive_inter : A ∩ (B ∪ C)  = (A ∩ B) ∪ (A ∩ C) := 
begin
    defi double_inclusion, ET,
    defi inclusion, qqs a, implique,
    hypo_analysis,
    goals_analysis,
    defi intersection_deux at H,
    hypo_analysis,
    goals_analysis,
    ET H,
    defi union at HB,
    OU HB,
      defi union, OU gauche,
      ET HA HA_1,
      defi intersection_deux at H,
      assumption,
    defi union, OU droite,
    defi intersection_deux, ET, assumption, assumption,
  defi inclusion, qqs a, implique,
  defi union at H,
  OU H,
    defi intersection_deux at HA,
    ET HA,
    OUd HB a ∈ C,  -- évitable en travaillant sur le but
    defi union at H,
    ET HA_1 H,
  defi intersection_deux at H_1,
  assumption,
  defi intersection_deux at HB,
  ET HB,
  defi intersection_deux,
  ET,
  assumption,
  defi union,
  tautology,
end

/- 
@Exercise
Union d'intersections
@Description
L'union est distributive par rapport à l'intersection 
-/
lemma inter_distributive_union : A ∪ (B ∩ C)  = (A ∪ B) ∩ (A ∪ C) := 
begin
    hypo_analysis,
    goals_analysis,
    sorry
end

end unions_et_intersections

-----------------------------------------
-----------------------------------------
section complementaire -- sous-section 2
-----------------------------------------
-----------------------------------------
variables {X : Type} {A B : set X}
variables {I : Type} {E F : I → set X}
-- notation X `\` A := @has_neg.neg (set X) _ A
-- notation  ` \` Z := has_neg.neg Z   
-- notation `\ ` Z := -Z

/- 
@Exercise
Complémentaire du complémentaire
@Description
Tout ensemble est égal au complémentaire de son complémentaire
-/
lemma complement_complement : - - A =A :=
begin
    hypo_analysis,
    sorry
end

/- 
@Exercise
Complémentaire d'union I
@Description
Le complémentaire de l'union de deux ensembles égale l'intersection des complémentaires 
-/
lemma complement_union_deux : @has_neg.neg (set X) _ (A ∪ B) = (- A) ∩ (- B) :=
begin    
    hypo_analysis,
    goals_analysis,
    sorry
end



/- 
@Exercise
Complémentaire d'union II
@Description
Le complémentaire d'une réunion quelconque égale l'intersection des complémentaires 
-/
open set
-- set_option pp.all true
lemma complement_union_quelconque  (H : ∀ i, F i = - E i) : - (Union E) = Inter F :=

begin
    hypo_analysis,
    goals_analysis,
    sorry
end

/- @EXERCICE Le complémentaire d'une intersection quelconque égale l'union des complémentaires -/
-- set_option pp.all true
lemma complement_intersection_quelconque  (H : ∀ i, F i = - E i) : - (Inter E) = Union F :=
begin   
    sorry
end
/- @EXERCICE Le complémentaire du vide est X ??? -/ 



/- @EXERCICE A est inclus dans B ssi le complémentaire de A contient le complémentaire de B -/
lemma inclus_ssi_complement_contient : A ⊆ B ↔ - B ⊆ - A :=
begin    
    hypo_analysis,
    goals_analysis,
    defi double_implication,    ET, 
        implique,
        defi inclusion, qqs a, implique, 
        defi complement,
        by_contradiction,
        -- alternative : defi inclusion at H, qqselim H a, impliqueelim H_2 a_1,
        applique H a_1,
        -- alternative : tautology, -- le contexte contient P et non P
        applique H_1 H_2, assumption,
    implique,
    defi inclusion, qqs a, implique,
    by_contradiction,
    applique H a_1,
    applique H_2 H_1, assumption,
    -- alternative :  defi inclusion at H, qqselim H a, impliqueelim H_3 H_2,
    -- tautology -- a remplacer : trop puissant !
end


/- -/
example : A ⊆ B ↔ B - A = ∅ :=
begin
    hypo_analysis,
    goals_analysis,
    sorry
end

-- Comment manipuler l'ensemble vide dans un type ?

/- Autres : différence symétrique-/




end complementaire



-- Ajouter : 3. produit cartésien, 4. relations ?
-- comment définit-on un produit cartésien d'ensembles ?



-----------------------------------------
-----------------------------------------
section applications  -- sous-section 5
-----------------------------------------
-----------------------------------------
notation f `⟮` A `⟯` := f '' A
notation f `⁻¹⟮` A `⟯` := f  ⁻¹' A

variables {X : Type} (A A': set X) 
variables {Y: Type} {f: X → Y} (B B': set Y)
variables {I : Type} {E : I → set X} {F : I → set Y}

/- @EXERCICE -/
lemma image_de_reciproque : f '' (f ⁻¹' B)  ⊆ B :=
begin
    hypo_analysis,
    goals_analysis,
    sorry
end

/- @EXERCICE -/
lemma reciproque_de_image : A ⊆ f ⁻¹' (f '' A) :=
begin
    sorry
end

/- @EXERCICE -/
lemma image_reciproque_inter :  f ⁻¹'  (B∩B') = f ⁻¹'  (B) ∩ f ⁻¹'  (B') :=
begin
    sorry
end


/- @EXERCICE -/
lemma  image_reciproque_union  : f ⁻¹' (B ∪ B') = f ⁻¹' B ∪ f ⁻¹' B'  :=
begin
    defi double_inclusion,
    ET,
        defi inclusion,
        hypo_analysis,
        goals_analysis,
        qqs x,
        implique,
        defi image_reciproque at H,
        defi union,
        defi union at H,
        OU H,
        defi image_reciproque at HA,
        OUd HA (f x ∈ B),
            OU gauche, assumption,
        OU droite, assumption, 
-- ici assumption en fait un peu trop, 
-- on voudrait obliger à avoir appliqué la def de l'image réciproque avant
    defi inclusion, 
    qqs x,
    implique,
    defi image_reciproque,
    defi union,
    defi union at H,
    OU H,
        OU gauche, assumption,
    OU droite, assumption,
end


/- Idem union, intersection quelconques -/

/- @EXERCICE -/
lemma image_reciproque_inter_quelconque  (H : ∀ i:I,  (E i = f ⁻¹' (F i))) :  (f ⁻¹'  (set.Inter F)) = set.Inter E :=
begin
    defi double_inclusion, ET,
    {defi inclusion, qqs x,
    implique,
    defi image_reciproque at H_1,
    defi intersection_quelconque at H_1,
    defi intersection_quelconque,
    qqs i,
    applique H_1 i,
    defi image_reciproque at H_2,
    applique H i,
    rw ← H_3 at H_2,
    assumption},
    {




    }
end



/- @EXERCICE -/
lemma image_inter_inclus_inter_images   :  
        f '' (A∩A') ⊆ f '' (A) ∩ f '' (A') :=
begin
    -- Soit b un élément de  f(A'∩A)
    defi inclusion,
    qqsintro b,
    impliqueintro,
    -- ligne non indispensable :
    defi image at H,
    hypo_analysis,
    goals_analysis,
    existeelim a H, ET H,
    defi intersection_deux at HA, ET HA,
    defi intersection_deux, ET,
    defi image,
    existeintro a, ET,
    assumption, assumption,
    existeintro a, ET,
    assumption, assumption,
end


/- @EXERCICE L'image réciproque du complémentaire 
égale le complémentaire de l'image réciprqque-/


end applications

















end theorie_des_ensembles