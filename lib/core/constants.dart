
import 'package:idioms/models/idiom.dart';

const MASTER_IDIOMS_COUNT = 5;

const MAX_IDIOMS_PER_DAY = 5;

final SAMPLE_IDIOMS = [
  // ===================== BASIC (20) =====================
  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Break the ice",
    definition: "To initiate conversation in a social setting.",
    examples: [
      "He told a joke to break the ice at the party.",
      "She broke the ice with a friendly smile."
    ],
    translations: {"de": "So das Eis brechen"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Piece of cake",
    definition: "Something that is very easy to do.",
    examples: [
      "The test was a piece of cake.",
      "For her, cooking this dish is a piece of cake."
    ],
    translations: {"de": "Ein Kinderspiel"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Under the weather",
    definition: "Feeling slightly ill or unwell.",
    examples: [
      "I won’t come to work today, I’m feeling under the weather.",
      "She stayed home because she was under the weather."
    ],
    translations: {"de": "Sich unwohl fühlen"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Spill the beans",
    definition: "To reveal a secret or disclose information.",
    examples: [
      "Don’t spill the beans about the surprise party!",
      "He accidentally spilled the beans during lunch."
    ],
    translations: {"de": "Ein Geheimnis verraten"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Hit the sack",
    definition: "To go to bed or sleep.",
    examples: [
      "I’m really tired; I’m going to hit the sack.",
      "She usually hits the sack around 10 p.m."
    ],
    translations: {"de": "Ins Bett gehen"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Let the cat out of the bag",
    definition: "To accidentally reveal a secret.",
    examples: [
      "She let the cat out of the bag about the engagement.",
      "He let the cat out of the bag during the meeting."
    ],
    translations: {"de": "Ein Geheimnis ausplaudern"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Cost an arm and a leg",
    definition: "To be very expensive.",
    examples: [
      "Their new house cost an arm and a leg.",
      "That designer bag costs an arm and a leg."
    ],
    translations: {"de": "Ein Vermögen kosten"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Once in a blue moon",
    definition: "Something that happens very rarely.",
    examples: [
      "We go out for dinner once in a blue moon.",
      "He visits his hometown once in a blue moon."
    ],
    translations: {"de": "Sehr selten"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Hit the nail on the head",
    definition: "To describe exactly what is causing a situation or problem.",
    examples: [
      "You hit the nail on the head with that suggestion.",
      "Her analysis really hit the nail on the head."
    ],
    translations: {"de": "Den Nagel auf den Kopf treffen"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "The ball is in your court",
    definition: "It’s your decision or responsibility to act now.",
    examples: [
      "I’ve done all I can—the ball is in your court.",
      "The offer is on the table; now the ball is in their court."
    ],
    translations: {"de": "Du bist am Zug"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Add fuel to the fire",
    definition: "To make a bad situation worse.",
    examples: [
      "His rude comments only added fuel to the fire.",
      "Yelling back will just add fuel to the fire."
    ],
    translations: {"de": "Öl ins Feuer gießen"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Burn the midnight oil",
    definition: "To work late into the night.",
    examples: [
      "She was burning the midnight oil to finish the project.",
      "He burned the midnight oil preparing for the exam."
    ],
    translations: {"de": "Die Nacht durcharbeiten"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Bite the bullet",
    definition: "To endure a painful situation bravely.",
    examples: [
      "He decided to bite the bullet and accept the criticism.",
      "I had to bite the bullet and tell her the truth."
    ],
    translations: {"de": "In den sauren Apfel beißen"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Go the extra mile",
    definition: "To make more effort than necessary.",
    examples: [
      "She always goes the extra mile for her clients.",
      "He went the extra mile to finish the task on time."
    ],
    translations: {"de": "Sich besonders anstrengen"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Blow off steam",
    definition: "To release pent-up energy or emotion.",
    examples: [
      "He goes jogging to blow off steam after work.",
      "She shouted to blow off steam."
    ],
    translations: {"de": "Dampf ablassen"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Call it a day",
    definition: "To stop working for the day.",
    examples: [
      "We’ve done enough, let’s call it a day.",
      "After ten hours, they decided to call it a day."
    ],
    translations: {"de": "Für heute Schluss machen"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Cut corners",
    definition: "To do something in the easiest, quickest, or cheapest way.",
    examples: [
      "They cut corners to finish the project on time.",
      "Don’t cut corners when preparing the report."
    ],
    translations: {"de": "Ecken und Kanten abkürzen"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Keep an eye on",
    definition: "To watch carefully or supervise.",
    examples: [
      "Please keep an eye on the children.",
      "I’ll keep an eye on the situation."
    ],
    translations: {"de": "Im Auge behalten"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Sit tight",
    definition: "To wait patiently.",
    examples: [
      "Sit tight while I get more information.",
      "He told us to sit tight and wait for instructions."
    ],
    translations: {"de": "Abwarten"},
  ),

  Idiom.create(
    difficulty: Difficulty.basic,
    idiom: "Go back to square one",
    definition: "To start again from the beginning.",
    examples: [
      "The plan failed, so we had to go back to square one.",
      "We went back to square one after the experiment failed."
    ],
    translations: {"de": "Wieder am Anfang anfangen"},
  ),

// ===================== INTERMEDIATE (20) =====================
  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "Bite off more than you can chew",
    definition: "To take on more than one can handle.",
    examples: [
      "He bit off more than he could chew with this project.",
      "Don’t bite off more than you can chew with your schedule."
    ],
    translations: {"de": "Sich übernehmen"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "Burn bridges",
    definition: "To destroy relationships or opportunities.",
    examples: [
      "He burned bridges with his former employer.",
      "Be careful not to burn bridges at work."
    ],
    translations: {"de": "Brücken abbrechen"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "Hit the ground running",
    definition: "To start a task with enthusiasm and efficiency.",
    examples: [
      "She hit the ground running on her first day.",
      "We need to hit the ground running after the break."
    ],
    translations: {"de": "Richtig durchstarten"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "Jump on the bandwagon",
    definition: "To follow a trend or popular activity.",
    examples: [
      "He jumped on the bandwagon and bought the new phone.",
      "Many companies jumped on the bandwagon of sustainability."
    ],
    translations: {"de": "Auf den Zug aufspringen"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "Throw in the towel",
    definition: "To give up or admit defeat.",
    examples: [
      "After failing the test, he threw in the towel.",
      "The team threw in the towel after halftime."
    ],
    translations: {"de": "Das Handtuch werfen"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "Through thick and thin",
    definition: "In good times and bad.",
    examples: [
      "They stayed friends through thick and thin.",
      "She supported him through thick and thin."
    ],
    translations: {"de": "In guten wie in schlechten Zeiten"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "A blessing in disguise",
    definition: "Something that seems bad but turns out good.",
    examples: [
      "Losing that job was a blessing in disguise.",
      "Missing the bus was a blessing in disguise because I met an old friend."
    ],
    translations: {"de": "Ein Glück im Unglück"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "Cut to the chase",
    definition: "To get to the point without wasting time.",
    examples: [
      "Let’s cut to the chase and discuss the budget.",
      "He always cuts to the chase in meetings."
    ],
    translations: {"de": "Zur Sache kommen"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "Elephant in the room",
    definition: "An obvious problem that is being ignored.",
    examples: [
      "The unpaid bills were the elephant in the room.",
      "We avoided the elephant in the room during the discussion."
    ],
    translations: {"de": "Der Elefant im Raum"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "The last straw",
    definition: "The final problem in a series of problems.",
    examples: [
      "His rude comment was the last straw.",
      "When the car broke down again, it was the last straw."
    ],
    translations: {"de": "Der Tropfen, der das Fass zum Überlaufen bringt"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "Bark up the wrong tree",
    definition: "To make a wrong assumption or pursue the wrong course.",
    examples: [
      "If you blame her, you’re barking up the wrong tree.",
      "He was barking up the wrong tree with that idea."
    ],
    translations: {"de": "Auf dem Holzweg sein"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "Hit the jackpot",
    definition: "To have great success or luck.",
    examples: [
      "They hit the jackpot with their new invention.",
      "She hit the jackpot at the casino."
    ],
    translations: {"de": "Den großen Gewinn erzielen"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "Keep your chin up",
    definition: "To stay positive in difficult situations.",
    examples: [
      "Keep your chin up; things will improve.",
      "He kept his chin up despite the setbacks."
    ],
    translations: {"de": "Kopf hoch"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "Kick the bucket",
    definition: "To die.",
    examples: [
      "Unfortunately, their old dog kicked the bucket.",
      "He’s worried about what will happen if he kicks the bucket."
    ],
    translations: {"de": "Den Löffel abgeben"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "Let sleeping dogs lie",
    definition: "Do not disturb a situation that is currently fine.",
    examples: [
      "Don’t bring up the old argument—let sleeping dogs lie.",
      "He decided to let sleeping dogs lie."
    ],
    translations: {"de": "Schlafende Hunde nicht wecken"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "On thin ice",
    definition: "In a risky or dangerous situation.",
    examples: [
      "He’s on thin ice with his boss after being late.",
      "You’re on thin ice if you break the rules again."
    ],
    translations: {"de": "Auf dünnem Eis"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "Piece of the pie",
    definition: "A share of something valuable.",
    examples: [
      "He wants a piece of the pie in the business deal.",
      "Everyone wants a piece of the pie in the booming market."
    ],
    translations: {"de": "Ein Stück vom Kuchen"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "Pull someone’s leg",
    definition: "To joke or tease someone.",
    examples: [
      "Are you serious or just pulling my leg?",
      "He was pulling my leg about the story."
    ],
    translations: {"de": "Jemanden auf den Arm nehmen"},
  ),

  Idiom.create(
    difficulty: Difficulty.intermediate,
    idiom: "Take it with a grain of salt",
    definition: "To view something skeptically.",
    examples: [
      "Take his advice with a grain of salt.",
      "She told me the story, but I took it with a grain of salt."
    ],
    translations: {"de": "Mit Vorsicht genießen"},
  ),

// ===================== ADVANCED (10) =====================
  Idiom.create(
    difficulty: Difficulty.advanced,
    idiom: "Throw caution to the wind",
    definition: "To take a risk without worrying about consequences.",
    examples: [
      "He threw caution to the wind and invested all his money.",
      "She threw caution to the wind and accepted the job offer abroad."
    ],
    translations: {"de": "Alle Vorsicht über Bord werfen"},
  ),

  Idiom.create(
    difficulty: Difficulty.advanced,
    idiom: "Fly off the handle",
    definition: "To suddenly lose one’s temper.",
    examples: [
      "He flew off the handle when he heard the news.",
      "Don’t fly off the handle over minor issues."
    ],
    translations: {"de": "Aus der Haut fahren"},
  ),

  Idiom.create(
    difficulty: Difficulty.advanced,
    idiom: "Throw someone under the bus",
    definition: "To betray someone to save oneself.",
    examples: [
      "He threw his colleague under the bus to protect himself.",
      "Don’t throw me under the bus in front of the boss."
    ],
    translations: {"de": "Jemanden opfern, um sich zu retten"},
  ),

  Idiom.create(
    difficulty: Difficulty.advanced,
    idiom: "Bite the dust",
    definition: "To fail or die.",
    examples: [
      "Several startups bit the dust last year.",
      "His old car finally bit the dust."
    ],
    translations: {"de": "Den Geist aufgeben"},
  ),

  Idiom.create(
    difficulty: Difficulty.advanced,
    idiom: "Cross that bridge when you come to it",
    definition: "Deal with a problem when it arises, not before.",
    examples: [
      "Don’t worry about the exam now; we’ll cross that bridge when we come to it.",
      "We’ll cross that bridge when we come to it regarding finances."
    ],
    translations: {"de": "Die Brücke überqueren, wenn man dazu kommt"},
  ),

  Idiom.create(
    difficulty: Difficulty.advanced,
    idiom: "Cry over spilled milk",
    definition: "To be upset about something that cannot be undone.",
    examples: [
      "It’s no use crying over spilled milk.",
      "Don’t cry over spilled milk; just move on."
    ],
    translations: {"de": "Über verschüttete Milch weinen"},
  ),

  Idiom.create(
    difficulty: Difficulty.advanced,
    idiom: "The pot calling the kettle black",
    definition: "Criticizing someone for a fault you also have.",
    examples: [
      "He called her lazy, but that’s the pot calling the kettle black.",
      "It’s the pot calling the kettle black to complain about tardiness."
    ],
    translations: {"de": "Der Topf sagt zum Kessel, er sei schwarz"},
  ),

  Idiom.create(
    difficulty: Difficulty.advanced,
    idiom: "Let bygones be bygones",
    definition: "To forgive and forget past offenses.",
    examples: [
      "They decided to let bygones be bygones after the argument.",
      "Let bygones be bygones and move on."
    ],
    translations: {"de": "Vergangenes ruhen lassen"},
  ),

  Idiom.create(
    difficulty: Difficulty.advanced,
    idiom: "Go down in flames",
    definition: "To fail spectacularly.",
    examples: [
      "The project went down in flames after the software crashed.",
      "He went down in flames in the final exam."
    ],
    translations: {"de": "Im Fiasko enden"},
  ),

  Idiom.create(
    difficulty: Difficulty.advanced,
    idiom: "Put the kibosh on",
    definition: "To stop or end something decisively.",
    examples: [
      "The manager put the kibosh on the proposal.",
      "They put the kibosh on the party plans due to rain."
    ],
    translations: {"de": "Einem Ende setzen"},
  )
];