module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Regex exposing (..)


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    , age : Int
    }


model : Model
model =
    Model "" "" "" 0



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }

        Age age ->
            { model | age = Result.withDefault 0 (String.toInt age) }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", placeholder "Name", onInput Name ] []
        , input [ type_ "password", placeholder "Password", onInput Password ] []
        , input [ type_ "password", placeholder "Re-enter password", onInput PasswordAgain ] []
        , input [ type_ "number", placeholder "Age", onInput Age ] []
        , viewValidation model
        ]


viewValidation : Model -> Html Msg
viewValidation model =
    let
        passwordLength =
            String.length model.password

        containsLowerUpperAndNumbers =
            Regex.contains (regex "[a-z]+") model.password
                && Regex.contains (regex "[A-Z]+") model.password
                && Regex.contains (regex "[0-9]+") model.password

        ( color, message ) =
            if not (model.password == model.passwordAgain) then
                ( "red", "Password do not match!" )
            else if passwordLength <= 8 then
                ( "red", "Password must be 8 length at least!" )
            else if not containsLowerUpperAndNumbers then
                ( "red", "Password must be contains numbers, upper and lower case chars" )
            else
                ( "green", "OK" )
    in
        div [ style [ ( "color", color ) ] ] [ text message ]
