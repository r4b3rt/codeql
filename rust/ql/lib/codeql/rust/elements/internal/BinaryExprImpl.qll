/**
 * This module provides a hand-modifiable wrapper around the generated class `BinaryExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.BinaryExpr

/**
 * INTERNAL: This module contains the customizable definition of `BinaryExpr` and should not
 * be referenced directly.
 */
module Impl {
  /**
   * A binary operation expression. For example:
   * ```rust
   * x + y;
   * x && y;
   * x <= y;
   * x = y;
   * x += y;
   * ```
   */
  class BinaryExpr extends Generated::BinaryExpr {
    override string toString() { result = "... " + this.getOperatorName() + " ..." }
  }
}
