import { healthLogging } from '@meltwater/mlabs-health'

export default ({
  log,
  healthMonitor
} = {}) => async () => {
  healthLogging({log, healthMonitor})
}
