// generated by codegen/codegen.py, do not edit
/**
 * This module provides the generated definition of `ErasureExpr`.
 * INTERNAL: Do not import directly.
 */

private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.expr.internal.ImplicitConversionExprImpl::Impl as ImplicitConversionExprImpl

/**
 * INTERNAL: This module contains the fully generated definition of `ErasureExpr` and should not
 * be referenced directly.
 */
module Generated {
  /**
   * INTERNAL: Do not reference the `Generated::ErasureExpr` class directly.
   * Use the subclass `ErasureExpr`, where the following predicates are available.
   */
  class ErasureExpr extends Synth::TErasureExpr, ImplicitConversionExprImpl::ImplicitConversionExpr {
    override string getAPrimaryQlClass() { result = "ErasureExpr" }
  }
}
