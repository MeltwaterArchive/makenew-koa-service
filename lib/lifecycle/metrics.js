import { collectDefaultMetrics } from 'prom-client'

export default ({registry, isMetricsDisabled}) => {
  if (isMetricsDisabled) return
  collectDefaultMetrics({register: registry})
}
