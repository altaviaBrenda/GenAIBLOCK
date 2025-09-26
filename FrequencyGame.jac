walker FrequencyGame {
    has guess_frequency: int ;

    can start with root entry ;
    can process_guess with scan entry ;
}

node scan {
    has correct_frequency: int = 100 + (rand() % 101)
}

with entry:__main__ {
     # Spawn multiple game instances with different initial guesses
    root spawn FrequencyGame(guess_frequency=120)
    root spawn FrequencyGame(guess_frequency=130)
    root spawn FrequencyGame(guess_frequency=140)
    root spawn FrequencyGame(guess_frequency=150)
}

impl FrequencyGame.start {
    if not [root --> (`?scan)] {
        next = root ++> scan
    } else {
        next = [root --> (`?scan)]
    }
    visit next
}

impl FrequencyGame.process_guess {
    if [-->] {
        visit [-->]
    } else {
        if self.guess_frequency < here.correct_frequency {
            say "Too low! Try a higher frequency."
            here ++> scan
        } else if self.guess_frequency > here.correct_frequency {
            say "Too high! Try a lower frequency."
            here ++> scan
        } else {
            say "Tuned perfectly! You found the correct frequency."
            disengage
        }
    }
}

