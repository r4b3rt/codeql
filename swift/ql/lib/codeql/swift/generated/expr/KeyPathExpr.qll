// generated by codegen/codegen.py
/**
 * This module provides the generated definition of `KeyPathExpr`.
 * INTERNAL: Do not import directly.
 */

private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.expr.Expr
import codeql.swift.elements.KeyPathComponent
import codeql.swift.elements.type.TypeRepr

/**
 * INTERNAL: This module contains the fully generated definition of `KeyPathExpr` and should not
 * be referenced directly.
 */
module Generated {
  /**
   * A key-path expression.
   * INTERNAL: Do not reference the `Generated::KeyPathExpr` class directly.
   * Use the subclass `KeyPathExpr`, where the following predicates are available.
   */
  class KeyPathExpr extends Synth::TKeyPathExpr, Expr {
    override string getAPrimaryQlClass() { result = "KeyPathExpr" }

    /**
     * Gets the root of this key path expression, if it exists.
     */
    TypeRepr getRoot() {
      result =
        Synth::convertTypeReprFromRaw(Synth::convertKeyPathExprToRaw(this)
              .(Raw::KeyPathExpr)
              .getRoot())
    }

    /**
     * Holds if `getRoot()` exists.
     */
    final predicate hasRoot() { exists(this.getRoot()) }

    /**
     * Gets the `index`th component of this key path expression (0-based).
     */
    KeyPathComponent getComponent(int index) {
      result =
        Synth::convertKeyPathComponentFromRaw(Synth::convertKeyPathExprToRaw(this)
              .(Raw::KeyPathExpr)
              .getComponent(index))
    }

    /**
     * Gets any of the components of this key path expression.
     */
    final KeyPathComponent getAComponent() { result = this.getComponent(_) }

    /**
     * Gets the number of components of this key path expression.
     */
    final int getNumberOfComponents() { result = count(int i | exists(this.getComponent(i))) }
  }
}
