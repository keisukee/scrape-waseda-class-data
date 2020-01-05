require 'logger'

log = Logger.new('./tmp/log')
puts 4
puts "hogehogehoge"
log.info('info')
log.warn('warn')
log.error('error')
log.fatal('fatal')
log.unknown('+'*80)