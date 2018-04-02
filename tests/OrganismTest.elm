module OrganismTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import Organism exposing (..)


suite : Test
suite =
    describe "The Organism module"
        [ describe "Organism exists"
            [ test "init with a few cells" <|
                \_ ->
                    Expect.equal "uno" "uno"
            ]
        ]
