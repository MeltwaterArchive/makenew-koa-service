import { createContainer, asFunction, asValue } from 'awilix'

import createApp from './app'
import registerLifecycle from './lifecycle'

export default ({ config, log } = {}) => {
  const container = createContainer()

  container.register({ log: asValue(log) })
  registerLifecycle(container, config)

  container.register({
    app: asFunction(createApp).singleton()
  })

  return container
}
