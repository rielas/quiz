module Messages exposing (Msg(..), QuizMsg(..))

import Http
import Measurement
import Model


type Msg
    = StartQuiz
    | Quiz QuizMsg
    | Measured Measurement.Msg


type QuizMsg
    = Next
    | Answer Int
