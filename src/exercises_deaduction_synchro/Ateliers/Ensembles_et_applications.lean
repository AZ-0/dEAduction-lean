/-
This is a d∃∀duction file providing exercises for sets and maps. French version.
-/

import data.set
import tactic

-- dEAduction tactics
import structures2      -- hypo_analysis, targets_analysis
import utils            -- no_meta_vars
import user_notations   -- notations that can be used in deaduction UI for a new object

-- dEAduction definitions
import set_definitions

-------------------------
-- dEAduction METADATA --
-------------------------
/- dEAduction
Title
    Ensembles et applications
Author
    Frédéric Le Roux, Camille Lichère, Zoé Mesnil
Institution
    Université du monde
Description
    Ce fichier contient une série d'exercices concernant les opérations ensemblistes
    préservées par image directe ou réciproque par une application.
    ATTENTION, certains énoncés sont faux ! Si vous n'arrivez pas à démontrer un énoncé, 
    cherchez un contre-exemple...
AvailableProof
    proof_methods new_object
AvailableMagic
    assumption
AvailableExercises
  UNTIL_NOW -image_directe_et_inclusion_II -image_reciproque_et_inclusion_II -image_directe_et_intersection_II
  -image_de_image_reciproque_I -image_reciproque_de_image_II
  -injective_si_compo_injective_I -surjective_si_compo_surjective_II
  -image_directe_et_intersection_VI
AvailableDefinitions
  UNTIL_NOW -singleton -paire
AvailableTheorems
  UNTIL_NOW -image_singleton -image_paire
-/

local attribute [instance] classical.prop_decidable
---------------------------------------------
-- global parameters = implicit variables --
---------------------------------------------
section course
parameters {X Y Z: Type}


open set

------------------
-- COURSE TITLE --
------------------
namespace ensembles_et_applications
/- dEAduction
PrettyName
    Ensembles et applications
-/

namespace definitions
/- dEAduction
PrettyName
    Définitions
-/

namespace generalites
/- dEAduction
PrettyName
    Généralités
-/

lemma definition.inclusion {A B : set X} : A ⊆ B ↔ ∀ {x:X}, x ∈ A → x ∈ B :=
/- dEAduction
ImplicitUse
  True
-/
begin
    exact iff.rfl
end

lemma definition.egalite_deux_ensembles {A A' : set X} :
(A = A') ↔ ( ∀ x, x ∈ A ↔ x ∈ A' ) :=
/- dEAduction
PrettyName
    Egalité de deux ensembles
-/
begin
     exact set.ext_iff
end

-- Unfortunately split cannot work
lemma definition.double_inclusion (A A' : set X) :
A = A' ↔ (A ⊆ A' ∧ A' ⊆ A) :=
/- dEAduction
PrettyName
    Egalité de deux ensembles : double inclusion
ImplicitUse
  True
-/
begin
    exact set.subset.antisymm_iff
end

lemma definition.ensemble_vide
{A: set X} :
(A = ∅) ↔ ∀ x : X, x ∉ A
:=
begin
    exact eq_empty_iff_forall_not_mem,
end

lemma theorem.ensemble_non_vide
(A: set X) :
(A ≠ ∅) ↔ ∃ x : X, x ∈ A
:=
begin
    todo
end

lemma definition.singleton
{x x_0: X} :
(x ∈  (sing x_0) ) ↔ x=x_0
:=
begin
    refl,
end

lemma definition.paire
{x x_0 x_1: X} :
(x ∈ (pair x_0 x_1) ) ↔ (x=x_0 ∨ x=x_1)
:=
begin
    refl,
end

end generalites

---------------
-- SECTION 1 --
---------------
namespace unions_et_intersections
-- variables unions_et_intersections --
variables {A B C : set X}

lemma definition.intersection_deux_ensembles {A B : set X} {x : X} :
x ∈ A ∩ B ↔ ( x ∈ A ∧ x ∈ B) :=
/- dEAduction
PrettyName
    Intersection de deux ensembles
ImplicitUse
    True
-/
begin
    exact iff.rfl
end

lemma definition.union_deux_ensembles  {A : set X} {B : set X} {x : X} :
x ∈ A ∪ B ↔ ( x ∈ A ∨ x ∈ B) :=
/- dEAduction
PrettyName
    Union de deux ensembles
ImplicitUse
    True
-/
begin
    exact iff.rfl
end

end unions_et_intersections


namespace applications

-- variables applications --

variables  {A A': set X}
variables {f: X → Y} {B B': set Y}

lemma definition.image_directe (y : Y) :
y ∈ f '' A ↔ ∃ x : X, x ∈ A ∧  f x = y
:=
begin
    todo
end

lemma theorem.image_directe :
∀ f: X→Y, ∀{A: set X}, ∀{x: X},
 (x ∈ A → f x ∈ f '' A)
:=
begin
    todo
end

lemma definition.image_reciproque (x:X) :
x ∈ f  ⁻¹' B ↔ f(x) ∈ B
:=
begin
    todo
end

variables (g : Y → Z)

lemma definition.composition {x:X}:
composition g f x = g (f x)
:=
begin
    todo,
end

lemma definition.injectivite :
injective f ↔ ∀ x x' : X, (f x = f x' → x = x')
:=
/- dEAduction
PrettyName
    Application injective
ImplicitUse
    True
-/
begin
    refl,
end

lemma definition.surjectivite :
surjective f ↔ ∀ y : Y, ∃ x : X, y = f x
:=
/- dEAduction
PrettyName
    Application surjective
ImplicitUse
    True
-/
begin
    refl,
end

lemma theorem.image_singleton :
∀ {f: X→Y}, ∀{x_0: X},
 f '' (sing x_0) = sing (f(x_0))
:=
/- dEAduction
PrettyName
  Image d'un singleton
-/
begin
    todo
end

lemma theorem.image_paire :
∀ {f: X→Y}, ∀{x_0 x_1: X},
 f '' (pair x_0 x_1) = pair (f x_0) (f x_1)
:=
/- dEAduction
PrettyName
  Image d'une paire
-/
begin
    todo
end

end applications

end definitions

-----------------
--- EXERCICES ---
-----------------
namespace exercices
variables  {A A': set X}
variables {f: X → Y} {g: Y → Z} {B B': set Y}

/-
ANCIEN SCHEMA :

1. ∀A,B⊆E A⊆B⇒f(A)⊆f(B)
2. ∀A,B⊆E f(A)⊆f(B)⇒A⊆B
3. Sif estinjective,alors∀A,B⊆E f(A)⊆f(B)⇒A⊆B
4. f est injective sietseulementsi ∀A,B⊆E f(A)⊆f(B)⇒A⊆B

5. ∀A,B⊆F A⊆B⇒f−1(A)⊆f−1(B)
6. ∀A,B⊆F f−1(A)⊆f−1(B)⇒A⊆B
7. Si f est surjective, alors ∀A,B ⊆ F f−1(A) ⊆ f−1(B) ⇒ A ⊆ B
8. festsurjectivesietseulementsi∀A,B⊆F f−1(A)⊆f−1(B)⇒A⊆B

9. ∀A ⊆ F f(f−1(A)) ⊆ A
10. ∀A ⊆ F A ⊆ f(f−1(A))
11. Si f est surjective, alors ∀A ⊆ F A ⊆ f(f−1(A))
12. f est surjective si et seulement si ∀A ⊆ F A = f(f−1(A))

13. ∀A ⊆ E A ⊆ f−1(f(A))
14. ∀A ⊆ E f−1(f(A)) ⊆ A
15. Si f est injective alors ∀A ⊆ E f−1(f(A)) ⊆ A
16. f est injective si et seulement si ∀A ⊆ E f−1(f(A)) = A

17. ∀A,B⊆E f(A∩B)⊆f(A)∩f(B)
18. ∀A,B⊆E f(A)∩f(B)⊆f(A∩B)
19. Sif estinjective,alors∀A,B⊆E f(A)∩f(B)⊆f(A∩B)
20. f estinjectivesietseulementsi∀A,B⊆E f(A)∩f(B)=f(A∩B)

21. ∀A,B⊆E 22.∀A,B⊆F 23.∀A,B⊆F
22. f(A∪B)=f(A)∪f(B)
23. f−1(A ∩ B) = f−1(A) ∩ f−1(B) f−1(A ∪ B) = f−1(A) ∪ f−1(B)
-/

-----------------------------------------------------------
-- Atelier 2 : images directe et réciproque, composition --
-----------------------------------------------------------
namespace composition_et_images

lemma exercise.composition_image_directe
(A: set X) : 
(composition g f) '' A = g '' (f '' A)
:=
/- dEAduction
PrettyName
    Image directe par une composition
-/
begin
    have H:= @definitions.applications.theorem.image_directe,
    hypo_analysis,
    todo
end


lemma exercise.composition_image_reciproque
(C: set Z) : 
(composition g f) ⁻¹' C = f ⁻¹' (g ⁻¹' C)
:=
/- dEAduction
PrettyName
    Image réciproque par une composition
-/
begin
    todo
end

end composition_et_images

namespace image_et_image_reciproque
/- dEAduction
PrettyName
  Image et image réciproque
-/

lemma exercise.image_reciproque_de_image_I :
∀ A, A ⊆ f ⁻¹' (f '' (A))
:=
/- dEAduction
PrettyName
  Image réciproque de l'image
-/
begin
  todo
end

lemma exercise.image_reciproque_de_image_II :
∀ A, f ⁻¹' (f '' (A)) ⊆ A
:=
/- dEAduction
PrettyName
  Image réciproque de l'image : inclusion réciproque
-/
begin
  todo
end

lemma exercise.image_de_image_reciproque_I :
∀ B, B ⊆ f '' (f ⁻¹' (B))
:=
/- dEAduction
PrettyName
  Image de l'image réciproque
-/
begin
  todo
end

lemma exercise.image_de_image_reciproque_II :
∀ B, f '' (f ⁻¹' (B)) ⊆ B
:=
/- dEAduction
PrettyName
  Image de l'image réciproque : inclusion réciproque
-/
begin
  todo
end

end image_et_image_reciproque


------------------------------------
-- Atelier 3 : Rédiger une preuve --
------------------------------------

---------------------------------
namespace images_inclusion
/- dEAduction
PrettyName
  Images et inclusion
-/

lemma exercise.image_directe_et_inclusion :
∀ A A': set X, A ⊆ A' → f '' (A) ⊆ f '' (A')
:=
/- dEAduction
PrettyName
  Image directe et inclusion
-/
begin
  todo
end

-- lemma exercise.image_directe_et_inclusion_II :
-- ∀ A A': set X,  f '' (A) ⊆ f '' (A') → A ⊆ A'
-- :=
-- /- dEAduction
-- PrettyName
--   Image directe et inclusion : implication réciproque
-- -/
-- begin
--   todo
-- end

lemma exercise.image_reciproque_et_inclusion :
∀ B B': set Y, B ⊆ B' → f ⁻¹' (B) ⊆ f ⁻¹' (B')
:=
/- dEAduction
PrettyName
  Image réciproque et inclusion
-/
begin
  todo
end

-- lemma exercise.image_reciproque_et_inclusion_II :
-- ∀ B B': set Y,  f ⁻¹' (B) ⊆ f ⁻¹' (B') → B ⊆ B'
-- :=
-- /- dEAduction
-- PrettyName
--   Image réciproque et inclusion : implication réciproque
-- -/
-- begin
--   todo
-- end

end images_inclusion


namespace images_union
/- dEAduction
PrettyName
  Images et union
-/

lemma exercise.image_directe_union :
∀ A A' : set X, f '' ( A ∪ A') = f '' (A) ∪ f '' (A')
:=
/- dEAduction
PrettyName
  Image directe et union
-/
begin
  todo
end

lemma exercise.image_reciproque_union :
∀ B B' : set Y, f ⁻¹' ( B ∪ B') = f ⁻¹' (B) ∪ f ⁻¹' (B')
:=
/- dEAduction
PrettyName
  Image réciproque et union
-/
begin
  todo
end

end images_union


------------------------------------------
-- Atelier 4 : Injectivité, surjectvité --
------------------------------------------

namespace injectivite_surjectivite_composition
/- dEAduction
PrettyName
    Injectivité/surjectivité et composition
-/

lemma exercise.composition_injections
(H1 : injective f) (H2 : injective g)
:
injective (composition g f)
:=
/- dEAduction
PrettyName
    Composition d'injections
-/
begin
    todo
end

lemma exercise.composition_surjections
(H1 : surjective f) (H2 : surjective g) :
surjective (composition g f)
:=
/- dEAduction
PrettyName
    Composition de surjections
-/
begin
    todo
end

lemma exercise.injective_si_compo_injective_I
(H1 : injective (composition g f)) :
injective g
:=
/- dEAduction
PrettyName
    Injective si composition injective (i) 
-/
begin
    todo
end

lemma exercise.injective_si_compo_injective_II
(H1 : injective (composition g f)) :
injective f
:=
/- dEAduction
PrettyName
    Injective si composition injective (ii)
-/
begin
    todo
end

lemma exercise.surjective_si_compo_surjective_I
(H1 : surjective (composition g f)) :
surjective g
:=
/- dEAduction
PrettyName
    Surjective si composition surjective (i)
-/
begin
    todo
end

lemma exercise.surjective_si_coompo_surjective_II
(H1 : surjective (composition g f)) :
surjective f
:=
/- dEAduction
PrettyName
    Surjective si composition surjective (ii)
-/
begin
    todo
end

end injectivite_surjectivite_composition


-------------------------------------------------
-- Atelier 5 : Conjecturer, démontrer, rédiger --
-------------------------------------------------
namespace image_intersection
/- dEAduction
PrettyName
  Image de l'intersection
-/

lemma exercise.image_directe_et_intersection_I :
∀ A B: set X, f '' (A ∩ B) ⊆ f '' (A) ∩ f '' (B)
:=
/- dEAduction
PrettyName
  Image directe et intersection (i)
-/
begin
  todo
end

lemma exercise.image_directe_et_intersection_II :
∀ A B: set X,  f '' (A) ∩ f '' (B) ⊆ f '' (A ∩ B)
:=
/- dEAduction
PrettyName
  Image directe et intersection (ii)
-/
begin
  todo
end

lemma exercise.image_directe_et_intersection_III
(H : injective f) :
∀ A B: set X,  f '' (A) ∩ f '' (B) ⊆ f '' (A ∩ B)
:=
/- dEAduction
PrettyName
  Image directe et intersection (iii)
-/
begin
  todo
end

lemma exercise.image_directe_et_intersection_VI
(H : surjective f) :
∀ A B: set X,  f '' (A) ∩ f '' (B) ⊆ f '' (A ∩ B)
:=
/- dEAduction
PrettyName
  Image directe et intersection (iv)
-/
begin
  todo
end

lemma exercise.image_reciproque_inter :
∀ A' B' : set Y, f ⁻¹' ( A' ∩ B') = f ⁻¹' (A') ∩ f ⁻¹' (B')
:=
/- dEAduction
PrettyName
  Image réciproque et intersection
-/
begin
  todo
end

end image_intersection


namespace image_et_image_reciproque_II
/- dEAduction
PrettyName
  Image et image réciproque II
-/

lemma exercise.image_reciproque_de_image_III :
(injective f) → ∀ A, f ⁻¹' (f '' (A)) ⊆ A
:=
/- dEAduction
PrettyName
  Image réciproque de l'image, et injectivité
-/
begin
  todo
end

lemma exercise.image_reciproque_de_image_IV :
(surjective f) → ∀ A, f ⁻¹' (f '' (A)) ⊆ A
:=
/- dEAduction
PrettyName
  Image réciproque de l'image, et surjectivité
-/
begin
  todo
end

lemma exercise.image_de_image_reciproque_III :
(injective f) → ∀ B, B ⊆ f '' (f ⁻¹' (B))
:=
/- dEAduction
PrettyName
  Image de l'image réciproque, et injectivité
-/
begin
  todo
end

lemma exercise.image_de_image_reciproque_IV :
(surjective f) → ∀ B, B ⊆ f '' (f ⁻¹' (B))
:=
/- dEAduction
PrettyName
  Image de l'image réciproque, et surjectivité
-/
begin
  todo
end

end image_et_image_reciproque_II


namespace injectivite_surjectivite_caracterisation
/- dEAduction
PrettyName
  Formules caractérisant l'injectivité et la surjectivité
-/

lemma exercise.caracterisation_injectivite :
∀ f: X→Y, (∀ A: set X, A = f ⁻¹' (f '' A)) → injective f
:=
/- dEAduction
PrettyName
  Une caractérisation de l'injectivité
AvailableDefinitions
  UNTIL_NOW
AvailableTheorems
  UNTIL_NOW
-/
begin
  todo
end

lemma exercise.caracterisation_surjectivite :
∀ f: X→Y, (∀ B: set Y, B = f '' (f ⁻¹' B) ) → surjective f
:=
/- dEAduction
PrettyName
  Une caractérisation de la surjectivité
AvailableDefinitions
  UNTIL_NOW
AvailableTheorems
  UNTIL_NOW
-/
begin
  todo
end

lemma exercise.caracterisation_injectivite_II :
∀ f: X→Y, (∀ A A': set X, f '' A ⊆ f '' A' → A ⊆ A' ) → injective f
:=
/- dEAduction
PrettyName
  Une autre caractérisation de l'injectivité
AvailableDefinitions
  UNTIL_NOW
AvailableTheorems
  UNTIL_NOW
-/
begin
  todo
end

lemma exercise.caracterisation_injectivite_III :
∀ f: X→Y, (∀ A A': set X, f '' (A ∩  A') = f '' A ∩ f '' A' ) → injective f
:=
/- dEAduction
PrettyName
  Une autre caractérisation de l'injectivité
AvailableDefinitions
  UNTIL_NOW
AvailableTheorems
  UNTIL_NOW
-/
begin
  todo
end

lemma exercise.caracterisation_surjectivite_II :
∀ f: X→Y, (∀ B B': set Y, (f ⁻¹' B ⊆ f ⁻¹' B' → B ⊆ B') ) → surjective f
:=
/- dEAduction
PrettyName
  Une autre caractérisation de la surjectivité
AvailableDefinitions
  UNTIL_NOW
AvailableTheorems
  UNTIL_NOW
-/
begin
  todo
end

end injectivite_surjectivite_caracterisation


namespace injectivite_surjectivite_autres
/- dEAduction
PrettyName
  Injectivité/surjectivité : divers
-/
 
lemma exercise.injectivite_surjecivite (f: X → Y) (g: Y → Z)
(H1 : injective (composition g f)) (H2 : surjective f)
:
injective g
:=
/- dEAduction
PrettyName
    Injectivité et surjectivité
-/
begin
    todo
end

lemma exercise.injectivite_categorielle
(f: Y → Z):
(injective f) → (∀X: Type, ∀ g h : X → Y, (composition f g) = (composition f h) → g = h)
:=
/- dEAduction
PrettyName
    Injectivité catégorielle
-/
begin
    todo
end

lemma exercise.surjectivite_categorielle
(f: X → Y):
(surjective f) →  (∀Z: Type, ∀ g h : Y → Z, (composition g f ) = (composition h f ) → g = h)
:=
/- dEAduction
PrettyName
    Surjectivité catégorielle
-/
begin
    todo
end

lemma exercise.surjective_ssi_inverse_droite : (surjective f) ↔
∃ F: Y → X, (composition f F) = Identite :=
/- dEAduction
PrettyName
    (*) Surjectivité et inverse à droite
-/
begin
    todo
end

lemma exercise.image_directe_et_inclusion_III :
(injective f) →  (∀ A B: set X,  f '' (A) ⊆ f '' (B) → A ⊆ B)
:=
/- dEAduction
PrettyName
  Image directe et inclusion (iii)
-/
begin
  todo
end

lemma exercise.image_reciproque_et_inclusion_III :
(surjective f) → (∀ A' B': set Y,  f ⁻¹' (A') ⊆ f ⁻¹' (B') → A' ⊆ B')
:=
/- dEAduction
PrettyName
  Image réciproque et inclusion (iii)
-/
begin
  todo
end

end injectivite_surjectivite_autres

end exercices

end ensembles_et_applications

end course


