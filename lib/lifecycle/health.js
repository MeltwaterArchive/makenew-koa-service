import {
  createHealthMonitor,
  createHealthy,
  healthLogging
} from '@meltwater/mlabs-health'

export const healthMethods = {
  health: createHealthy()
}

export const logHealth = ({
  log,
  healthMonitor
}) => () => healthLogging({log, healthMonitor})

export default () => createHealthMonitor({
  http: true
})
