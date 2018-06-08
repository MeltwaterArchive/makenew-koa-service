import {
  createHealthMonitor,
  healthLogging
} from '@meltwater/mlabs-health'

const createHealthy = ({
  maxUnhealthyDuration
} = {}) => ({
  healthy,
  unhealthy,
  duration
}) => {
  if (unhealthy && duration >= maxUnhealthyDuration) return false
  return true
}

export const healthMethods = options => ({
  health: createHealthy(options)
})

export const logHealth = ({
  log,
  healthMonitor
}) => () => healthLogging({log, healthMonitor})

export default () => createHealthMonitor({
  http: true
})
