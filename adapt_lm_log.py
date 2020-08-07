from talon import Module, actions, speech_system
from talon_init import TALON_HOME

OUTPUT_FILE = TALON_HOME / "adapt-log"


def post_phrase(d):
    phrase = " ".join(getattr(d["parsed"], "_unmapped", d["phrase"]))
    actions.self.store_phrase(phrase)


speech_system.register("post:phrase", post_phrase)

mod = Module()


@mod.action_class
class Actions:
    @staticmethod
    def store_phrase(phrase: str):
        """Record the phrase's text to a log for further tuning"""
        phrase = phrase.strip()
        if not phrase:
            return
        with OUTPUT_FILE.open("a") as fp:
            fp.write(f"{phrase}\n")
