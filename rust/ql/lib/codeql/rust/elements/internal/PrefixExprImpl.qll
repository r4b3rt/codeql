/**
 * This module provides a hand-modifiable wrapper around the generated class `PrefixExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.PrefixExpr

/**
 * INTERNAL: This module contains the customizable definition of `PrefixExpr` and should not
 * be referenced directly.
 */
module Impl {
  /**
   * A unary operation expression. For example:
   * ```rust
   * let x = -42
   * let y = !true
   * let z = *ptr
   * ```
   */
  class PrefixExpr extends Generated::PrefixExpr {
    override string toString() { result = this.getOperatorName() + " ..." }
  }
}
