module Messages exposing (Msg(..), QuizMsg(..))

import Analytics
import Http
import Model


type Msg
    = StartQuiz
    | Quiz QuizMsg
    | GotModel (Result Http.Error Model.Settings)
    | Measured Analytics.Msg


type QuizMsg
    = Next
    | Answer Int
