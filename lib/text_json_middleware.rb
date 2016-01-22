class TextJsonMiddleware
  def initialize app
    @app = app
  end

  def call env
    env['CONTENT_TYPE'] = 'application/json' if env['CONTENT_TYPE'] == 'text/json'
    @app.call env
  end
end
