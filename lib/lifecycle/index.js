import { asFunction, asValue } from 'awilix'

import createStart from './start'
import createStop from './stop'
import createHealthMonitor, { healthMethods } from './health'

export default (container) => {
  container.register({
    start: asFunction(createStart).singleton(),
    stop: asFunction(createStop).singleton(),
    healthMethods: asValue(healthMethods),
    healthMonitor: asFunction(createHealthMonitor).singleton()
  })
}
