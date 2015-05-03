# logjam only imports data for apps it knows about, so we need to
# declare them here:

module Logjam
  stream "gazelles-production"
  stream "antelopes-production"
  stream "zebras-production"
end
