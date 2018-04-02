module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode as Decode


-- MODEL


type alias Model =
    { topic : String
    , gifUrl : String
    , errorMessage : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "cats" "waiting.gif" "", Cmd.none )



--UPDATE


type Msg
    = MorePlease
    | NewGif (Result Http.Error String)
    | NewTopic String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( model, getRandomGif model.topic )

        NewGif (Ok newUrl) ->
            ( { model | gifUrl = newUrl, errorMessage = "" }, Cmd.none )

        NewGif (Err _) ->
            ( { model | errorMessage = "Epic fail" }, Cmd.none )

        NewTopic topic ->
            ( { model | topic = topic }, Cmd.none )


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic

        request =
            Http.get url decodeGifUrl
    in
        Http.send NewGif request


decodeGifUrl : Decode.Decoder String
decodeGifUrl =
    Decode.at [ "data", "image_url" ] Decode.string



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text model.topic ]
        , input [ type_ "text", placeholder "What the ...", onInput NewTopic ] []
        , img [ src model.gifUrl ] []
        , button [ onClick MorePlease ] [ text "More Please!" ]
        , h3 [ style [ ( "color", "red" ) ] ] [ text model.errorMessage ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
