module Messages exposing (Msg(..), QuizMsg(..))

import Http
import Model


type Msg
    = NoOp
    | Quiz QuizMsg
    | GotModel (Result Http.Error (List Model.Question))
    | Reset


type QuizMsg
    = Next
    | Answer Int
