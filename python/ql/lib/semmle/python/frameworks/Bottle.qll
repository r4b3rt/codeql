/**
 * Provides classes modeling security-relevant aspects of the `bottle` PyPI package.
 * See https://bottlepy.org/docs/dev/.
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper
private import semmle.python.frameworks.Stdlib

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `bottle` PyPI package.
 * See https://bottlepy.org/docs/dev/.
 */
module Bottle {
  /** Gets a reference to the `bottle` module. */
  API::Node bottle() { result = API::moduleImport("bottle") }

  /** Provides models for the `bottle` module. */
  module BottleModule {
    /**
     * Provides models for Bottle applications.
     */
    module App {
      /** Gets class `bottle.Bottle`) */
      API::Node cls() { result = API::moduleImport("bottle").getMember("Bottle") }

      /** Gets a reference to a Bottle application (an instance of `bottle.Bottle`) */
      API::Node instance() { result = cls().getReturn() }

      /** Gets a reference to a Bottle application (an instance of `bottle.app`) */
      API::Node app() { result = bottle().getMember("app").getReturn() }
    }

    /** Provides models for functions that are possible "views" */
    module View {
      /**
       * A Bottle view callable, that handles incoming requests.
       */
      class ViewCallable extends Function {
        ViewCallable() { this = any(BottleRouteSetup rs).getARequestHandler() }
      }

      private class BottleRouteSetup extends Http::Server::RouteSetup::Range, DataFlow::CallCfgNode {
        BottleRouteSetup() {
          this =
            [
              App::instance()
                  .getMember(["route", "get", "post", "put", "delete", "patch"])
                  .getACall(),
              App::app().getMember(["route", "get", "post", "put", "delete", "patch"]).getACall(),
              bottle().getMember(["route", "get", "post", "put", "delete", "patch"]).getACall()
            ]
        }

        override DataFlow::Node getUrlPatternArg() {
          result in [this.getArg(0), this.getArgByName("route")]
        }

        override string getFramework() { result = "Bottle" }

        override Parameter getARoutedParameter() { none() }

        override Function getARequestHandler() { result.getADecorator().getAFlowNode() = node }
      }
    }

    /** Provides models for the `bottle.response` module */
    module Response {
      /** Gets a reference to the `bottle.response` module. */
      API::Node response() { result = bottle().getMember("response") }

      /** A response returned by a view callable. */
      class BottleReturnResponse extends Http::Server::HttpResponse::Range {
        BottleReturnResponse() {
          this.asCfgNode() = any(View::ViewCallable vc).getAReturnValueFlowNode()
        }

        override DataFlow::Node getBody() { result = this }

        override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

        override string getMimetypeDefault() { result = "text/html" }
      }

      /**
       * A call to the `bottle.BaseResponse.set_header` or `bottle.BaseResponse.add_header` method.
       *
       * See https://bottlepy.org/docs/dev/api.html#bottle.BaseResponse.set_header
       */
      class BottleResponseHandlerSetHeaderCall extends Http::Server::ResponseHeaderWrite::Range,
        DataFlow::MethodCallNode
      {
        BottleResponseHandlerSetHeaderCall() {
          this = response().getMember(["set_header", "add_header"]).getACall()
        }

        override DataFlow::Node getNameArg() {
          result in [this.getArg(0), this.getArgByName("name")]
        }

        override DataFlow::Node getValueArg() {
          result in [this.getArg(1), this.getArgByName("value")]
        }

        override predicate nameAllowsNewline() { none() }

        override predicate valueAllowsNewline() { none() }
      }
    }

    /** Provides models for the `bottle.request` module */
    module Request {
      /** Gets a reference to the `bottle.request` module. */
      API::Node request() { result = bottle().getMember("request") }

      private class Request extends RemoteFlowSource::Range {
        Request() { this = request().asSource() }

        override string getSourceType() { result = "bottle.request" }
      }

      /**
       * Taint propagation for `bottle.request`.
       *
       * See https://bottlepy.org/docs/dev/api.html#bottle.request
       */
      private class InstanceTaintSteps extends InstanceTaintStepsHelper {
        InstanceTaintSteps() { this = "bottle.request" }

        override DataFlow::Node getInstance() { result = request().getAValueReachableFromSource() }

        override string getAttributeName() {
          result in [
              "headers", "query", "forms", "params", "json", "url", "body", "fullpath",
              "query_string"
            ]
        }

        override string getMethodName() { none() }

        override string getAsyncMethodName() { none() }
      }
    }

    /** Provides models for the `bottle.headers` module */
    module Headers {
      /** Gets a reference to the `bottle.headers` module. */
      API::Node headers() { result = bottle().getMember("response").getMember("headers") }

      /** A dict-like write to a response header. */
      class HeaderWriteSubscript extends Http::Server::ResponseHeaderWrite::Range, DataFlow::Node {
        DataFlow::Node name;
        DataFlow::Node value;

        HeaderWriteSubscript() {
          exists(SubscriptNode subscript |
            this.asCfgNode() = subscript and
            value.asCfgNode() = subscript.(DefinitionNode).getValue() and
            name.asCfgNode() = subscript.getIndex() and
            subscript.getObject() = headers().asSource().asCfgNode()
          )
        }

        override DataFlow::Node getNameArg() { result = name }

        override DataFlow::Node getValueArg() { result = value }

        override predicate nameAllowsNewline() { none() }

        override predicate valueAllowsNewline() { none() }
      }
    }
  }
}
