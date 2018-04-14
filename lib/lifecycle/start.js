import { healthLogging } from '@meltwater/mlabs-health'

import collectMetrics from './metrics'

export default ({
  log,
  registry,
  healthMonitor
} = {}) => async () => {
  healthLogging({log, healthMonitor})
  collectMetrics({registry})
}
