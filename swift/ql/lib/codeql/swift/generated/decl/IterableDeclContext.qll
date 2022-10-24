// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.decl.Decl
import codeql.swift.elements.Element

module Generated {
  class IterableDeclContext extends Synth::TIterableDeclContext, Element {
    /**
     * Gets the `index`th member of this iterable declaration context (0-based).
     *
     * This includes nodes from the "hidden" AST. It can be overridden in subclasses to change the
     * behavior of both the `Immediate` and non-`Immediate` versions.
     */
    Decl getImmediateMember(int index) {
      result =
        Synth::convertDeclFromRaw(Synth::convertIterableDeclContextToRaw(this)
              .(Raw::IterableDeclContext)
              .getMember(index))
    }

    /**
     * Gets the `index`th member of this iterable declaration context (0-based).
     */
    final Decl getMember(int index) { result = getImmediateMember(index).resolve() }

    /**
     * Gets any of the members of this iterable declaration context.
     */
    final Decl getAMember() { result = getMember(_) }

    /**
     * Gets the number of members of this iterable declaration context.
     */
    final int getNumberOfMembers() { result = count(getAMember()) }
  }
}
