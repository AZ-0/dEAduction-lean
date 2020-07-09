import tactic
import data.real.basic
import data.set
import data.set.lattice
import logics
import definitions


set_option trace.simplify.rewrite true
-- set_option pp.all true


variables {X : Type} {Y : Type}
-- mem_compl_iff
--lemma complement {A : set X} {x : X} : x ∈ - A ↔ ¬ x ∈ A :=
--iff.rfl


----------------------------------------------
namespace set_theory
----------------------------------------------

lemma definitions.inclusion (A B : set X) : A ⊆ B ↔ ∀ {{x:X}}, x ∈ A → x ∈ B := 
iff.rfl


lemma definition.egalite_ensembles {A A' : set X} : (A = A') ↔ ( ∀ x, x ∈ A ↔ x ∈ A' ) :=
by exact set.ext_iff

lemma theorem.double_inclusion {A A' : set X} : (A = A') ↔ (A ⊆ A' ∧ A' ⊆ A) :=
begin
    exact le_antisymm_iff
end


----------------------------------------------
namespace unions_and_intersections -- section 1
----------------------------------------------


lemma definition.intersection_deux  (A B : set X) (x : X) :  x ∈ A ∩ B ↔ ( x ∈ A ∧ x ∈ B) := 
iff.rfl

lemma theorem.intersection_ensemble  (A B C : set X) : C ⊆ A ∩ B ↔ C ⊆ A ∧ C ⊆ B := 
begin
    exact ball_and_distrib
end

lemma definition.intersection_quelconque (I : Type) (O : I → set X)  (x : X) : (x ∈ set.Inter O) ↔ (∀ i:I, x ∈ O i) :=
set.mem_Inter

-- Les deux lemmes suivants seront à regroupé au sein d'une même tactique : essayer le premier, 
-- en cas d'échec essayer le second. Un seul bouton dans l'interface graphique
lemma definition.union  (A : set X) (B : set X) (x : X) :  x ∈ A ∪ B ↔ ( x ∈ A ∨ x ∈ B) := 
iff.rfl

lemma definition.union_quelconque (I : Type) (O : I → set X)  (x : X) : (x ∈ set.Union O) ↔ (∃ i:I, x ∈ O i) :=
set.mem_Union

end unions_and_intersections

-----------------------------------------
namespace complements -- section 2
----------------------------------------------

lemma definition.complement {A : set X} {x : X} : x ∈ set.univ \ A ↔ x ∉ A := 
by finish

lemma definition.complement_1 {A : set X} {x : X} : x ∈ set.compl A ↔ x ∉ A := 
by finish

lemma definition.complement_2 {A B : set X} {x : X} : x ∈ B \ A ↔ (x ∈ B ∧ x ∉ A) :=
iff.rfl

end complements

end set_theory

