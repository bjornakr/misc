import api.Service
import cats.effect.IO
//import cats.implicits._
import org.http4s.server.blaze._
//import org.http4s.implicits._
import fs2.{Stream, StreamApp}
import fs2.StreamApp.ExitCode
import scala.concurrent.ExecutionContext.Implicits.global


object Main extends StreamApp[IO] {
    private val services = Service.helloWorldService

    override def stream(args: List[String], requestShutdown: IO[Unit]): Stream[IO, ExitCode] =
        BlazeBuilder[IO]
            .bindHttp(8080, "localhost")
            .mountService(Service.helloWorldService, "/")
            .mountService(services, "/api")
            .serve

}
