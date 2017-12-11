import { createHealthMonitor, createHealthy } from '@meltwater/mlabs-health'

export const healthMethods = {
  health: createHealthy()
}

export default () => createHealthMonitor({
  http: true
})
