-- ServiceFactory.moon

class ServiceFactory
  __SERVICES: {}
  __inherited: (child) =>  -- Store newly instantiated SVC class
    @__SERVICES[child.__name]\insert child! unless __SERVICES[child.__name]
  GetService: (name) =>  -- return the stored SVC class
    @__SERVICES[svcName]

-- ServiceFactory.__class.__SERVICES.TEST_SVC = TEST_SVC!
class TEST_SVC extends ServiceFactory
  new: =>
    unless super\GetService @__name
      -- Do stuff now, ONLY if not yet existing.

{:ServiceFactory}