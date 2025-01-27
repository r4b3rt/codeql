/**
 * Provides a dataflow taint tracking configuration for reasoning
 * about CORS misconfiguration for credentials transfer.
 *
 * Note, for performance reasons: only import this file if
 * `CorsMisconfigurationForCredentials::Configuration` is needed,
 * otherwise `CorsMisconfigurationForCredentialsCustomizations` should
 * be imported instead.
 */

import javascript
import CorsMisconfigurationForCredentialsCustomizations::CorsMisconfigurationForCredentials

/**
 * A data flow configuration for CORS misconfiguration for credentials transfer.
 */
module CorsMisconfigurationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer or
    node = TaintTracking::AdHocWhitelistCheckSanitizer::getABarrierNode()
  }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getLocation()
    or
    result = sink.(Sink).getCredentialsHeader().getLocation()
  }
}

/**
 * Data flow for CORS misconfiguration for credentials transfer.
 */
module CorsMisconfigurationFlow = TaintTracking::Global<CorsMisconfigurationConfig>;
