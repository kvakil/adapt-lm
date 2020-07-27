from talon import Context, Module, actions, speech_system
from talon import speech_system
from talon_init import TALON_HOME

OUTPUT_FILE = TALON_HOME / "adapt-log"

current_phrase = None


def pre_phrase(d):
    global current_phrase
    current_phrase = d


def post_phrase(d):
    phrase = " ".join(getattr(d["parsed"], "_unmapped", d["phrase"]))
    actions.self.store_phrase(phrase)


speech_system.register("pre:phrase", pre_phrase)
speech_system.register("post:phrase", post_phrase)

mod = Module()


@mod.action_class
class Actions:
    @staticmethod
    def store_phrase(words: str):
        """Record the phrases text to a log for further tuning"""
        words = words.strip()
        if not current_phrase or not current_phrase.get("samples") or not words:
            return
        with OUTPUT_FILE.open("a") as fp:
            fp.write(f"{words}\n")
