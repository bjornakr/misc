package api

import cats.effect._
import io.circe.Decoder._
import io.circe.generic.auto._
import io.circe.parser._
import org.http4s._
import org.http4s.implicits._
import org.scalamock.scalatest.MockFactory
import org.scalatest.WordSpec

class ZergServiceTest extends WordSpec with MockFactory {
    "GET zerg id=1" when {
        "zerg exists" should {
            "return 200 Ok with Zerg in body" in {
                val zerg = Zerg(1, "Bobby Zergling", "zergling", 100)
                val fakeRepo = stub[ZergRepository]
                (fakeRepo.getById _).when(1).returns(IO(Some(zerg)))

                val req = Request[IO](Method.GET, ZergService.myUri / "1")
                val service = new ZergService(fakeRepo).zergService
                val io = service.orNotFound.run(req)
                val response: Response[IO] = io.unsafeRunSync
                val body = EntityDecoder.decodeString(response).unsafeRunSync()

                assertResult(Status.Ok) {
                    response.status
                }

                assertResult(zerg) {
                    decode[Zerg](body).right.get
                }
            }
        }
    }
}
