import { collectDefaultMetrics } from 'prom-client'

export default ({ registry, isMetricsDisabled }) => () => {
  if (isMetricsDisabled) return
  const register = registry
  collectDefaultMetrics({ register })
}
