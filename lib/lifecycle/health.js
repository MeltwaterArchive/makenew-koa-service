import {
  createHealthMonitor,
  healthLogging
} from '@meltwater/mlabs-health'

const createHealthy = ({
  maxUnhealthyDuration = 1000 * 60
} = {}) => ({
  healthy,
  unhealthy,
  duration
}) => {
  if (unhealthy && duration > maxUnhealthyDuration) return false
  return true
}

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
