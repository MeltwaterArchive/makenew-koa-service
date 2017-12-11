import { createContainer, asFunction, asValue } from 'awilix'

import createApp from './app'
import {
  createStart,
  createStop,
  createHealthMonitor,
  healthMethods
} from './lifecycle'

export default ({config, log} = {}) => {
  const container = createContainer()

  container.register({
    log: asValue(log),
    start: asFunction(createStart).singleton(),
    stop: asFunction(createStop).singleton(),
    healthMethods: asValue(healthMethods),
    healthMonitor: asFunction(createHealthMonitor).singleton(),
    app: asFunction(createApp).singleton()
  })

  return container
}
