import tornado.ioloop
import tornado.web
 
class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Hello, world")
 
application = tornado.web.Application([
    (r"/", MainHandler),
])
 
if __name__ == "__main__":
    application.listen(9999)
    tornado.ioloop.IOLoop.instance().start()
