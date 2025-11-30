class MainCategory {
  final String? id;
  final String? name;
  final String? video;
  final String? youtubeVideoId;
  final String? image;
  final List<SubCategory> subCategories;

  MainCategory({
    this.id,
    this.name,
    this.video,
    this.youtubeVideoId,
    this.image,
    this.subCategories = const [],
  });

  factory MainCategory.fromJson(Map<String, dynamic> json) {
    return MainCategory(
      id: json['id'] as String?,
      name: json['name'] as String?,
      video: json['video'] as String?,
      youtubeVideoId: json['youtubeVideoId'] as String?,
      image: json['image'] as String?,
      subCategories: (json['subCategories'] as List?)
              ?.map((e) => SubCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SubCategory {
  final String? id;
  final String? name;
  final String? video;
  final String? youtubeVideoId;
  final String? image;
  final List<MainTab> mainTabs;

  SubCategory({
    this.id,
    this.name,
    this.video,
    this.youtubeVideoId,
    this.image,
    this.mainTabs = const [],
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    List<MainTab> parsedMainTabs = [];
    if (json['mainTabs'] is List) {
      for (var mainTabJson in (json['mainTabs'] as List)) {
        if (mainTabJson is Map<String, dynamic>) {
          parsedMainTabs.add(MainTab.fromJson(mainTabJson));
        }
      }
    }

    return SubCategory(
      id: json['id'] as String?,
      name: json['name'] as String?,
      video: json['video'] as String?,
      youtubeVideoId: json['youtubeVideoId'] as String?,
      image: json['image'] as String?,
      mainTabs: parsedMainTabs,
    );
  }
}

class MainTab {
  final String? id;
  final String? name;
  final String? video;
  final String? youtubeVideoId;
  final String? image; // Added this field
  final List<SubTabBase> subTabs;

  MainTab({
    this.id,
    this.name,
    this.video,
    this.youtubeVideoId,
    this.image, // Added this field
    this.subTabs = const [],
  });

  factory MainTab.fromJson(Map<String, dynamic> json) {
    List<SubTabBase> parsedSubTabs = [];
    if (json['subTabs'] is List) {
      for (var subTabJson in (json['subTabs'] as List)) {
        if (subTabJson is Map<String, dynamic>) {
          final String? subTabId = subTabJson['id'] as String?;
          if (subTabId != null) {
            if (subTabId.startsWith('wordsOnly_')) {
              parsedSubTabs.add(WordsOnlySubTab.fromJson(subTabJson));
            } else if (subTabId.startsWith('sentenceMaking_')) {
              parsedSubTabs.add(SentenceMakingSubTab.fromJson(subTabJson));
            } else if (subTabId == 'sentenceOnly' || subTabId.startsWith('sentenceOnly_')) {
              parsedSubTabs.add(SentenceOnlySubTab.fromJson(subTabJson));
            } else if (subTabId.startsWith('assessment_')) {
              parsedSubTabs.add(AssessmentSubTab.fromJson(subTabJson));
            } else {
              parsedSubTabs.add(GenericSubTab.fromJson(subTabJson));
            }
          } else {
            // Fallback inference
            if (subTabJson.containsKey('words') && !subTabJson.containsKey('activities') && !subTabJson.containsKey('sentences')) {
              parsedSubTabs.add(WordsOnlySubTab.fromJson(subTabJson));
            } else if (subTabJson.containsKey('activities')) {
              parsedSubTabs.add(SentenceMakingSubTab.fromJson(subTabJson));
            } else if (subTabJson.containsKey('sentences')) {
              parsedSubTabs.add(SentenceOnlySubTab.fromJson(subTabJson));
            } else {
              parsedSubTabs.add(GenericSubTab.fromJson(subTabJson));
            }
          }
        }
      }
    }

    return MainTab(
      name: json['name'] as String?,
      id: json['id'] as String?,
      video: json['video'] as String?,
      youtubeVideoId: json['youtubeVideoId'] as String?,
      image: json['image'] as String?, // Added parsing here
      subTabs: parsedSubTabs,
    );
  }
}

// --- Base and specific models for content *within* subTabs ---

abstract class SubTabBase {
  final String? name;
  final String? id;
  final String? video;
  final String? youtubeVideoId;

  SubTabBase({
    this.name,
    this.id,
    this.video,
    this.youtubeVideoId,
  });
}

class GenericSubTab extends SubTabBase {
  final Map<String, dynamic> rawData;

  GenericSubTab({
    super.name,
    super.id,
    super.video,
    super.youtubeVideoId,
    this.rawData = const {},
  });

  factory GenericSubTab.fromJson(Map<String, dynamic> json) {
    return GenericSubTab(
      name: json['name'] as String?,
      id: json['id'] as String?,
      video: json['video'] as String?,
      youtubeVideoId: json['youtubeVideoId'] as String?,
      rawData: Map<String, dynamic>.from(json),
    );
  }
}

class WordsOnlySubTab extends SubTabBase {
  final bool? wordsOnly;
  final List<Word> words;

  WordsOnlySubTab({
    super.name,
    super.id,
    super.video,
    super.youtubeVideoId,
    this.wordsOnly,
    this.words = const [],
  });

  factory WordsOnlySubTab.fromJson(Map<String, dynamic> json) {
    return WordsOnlySubTab(
      name: json['name'] as String?,
      id: json['id'] as String?,
      video: json['video'] as String?,
      youtubeVideoId: json['youtubeVideoId'] as String?,
      wordsOnly: json['wordsOnly'] as bool?,
      words: (json['words'] as List?)
              ?.map((e) => Word.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SentenceMakingSubTab extends SubTabBase {
  final List<Activity> activities;

  SentenceMakingSubTab({
    super.name,
    super.id,
    super.video,
    super.youtubeVideoId,
    this.activities = const [],
  });

  factory SentenceMakingSubTab.fromJson(Map<String, dynamic> json) {
    return SentenceMakingSubTab(
      name: json['name'] as String?,
      id: json['id'] as String?,
      video: json['video'] as String?,
      youtubeVideoId: json['youtubeVideoId'] as String?,
      activities: (json['activities'] as List?)
              ?.map((e) => Activity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SentenceOnlySubTab extends SubTabBase {
  final bool? sentenceAndWords;
  final List<Word> words;
  final List<Sentence> sentences;

  SentenceOnlySubTab({
    super.name,
    super.id,
    super.video,
    super.youtubeVideoId,
    this.sentenceAndWords,
    this.words = const [],
    this.sentences = const [],
  });

  factory SentenceOnlySubTab.fromJson(Map<String, dynamic> json) {
    List<Word> parsedWords = [];
    if (json['words'] is List) {
      List<dynamic> rawWordsList = json['words'] as List<dynamic>;
      if (rawWordsList.isNotEmpty && rawWordsList.first is List) {
        for (var innerList in rawWordsList) {
          if (innerList is List) {
            parsedWords.addAll(innerList.map((e) => Word.fromJson(e as Map<String, dynamic>)).toList());
          }
        }
      } else {
        parsedWords = rawWordsList
            .map((e) => Word.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }

    return SentenceOnlySubTab(
      name: json['name'] as String?,
      id: json['id'] as String?,
      video: json['video'] as String?,
      youtubeVideoId: json['youtubeVideoId'] as String?,
      sentenceAndWords: json['sentenceAndWords'] as bool?,
      words: parsedWords,
      sentences: (json['sentences'] as List?)
              ?.map((e) => Sentence.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class AssessmentSubTab extends SubTabBase {
  final bool? assessment;

  AssessmentSubTab({
    super.name,
    super.id,
    super.video,
    super.youtubeVideoId,
    this.assessment,
  });

  factory AssessmentSubTab.fromJson(Map<String, dynamic> json) {
    return AssessmentSubTab(
      name: json['name'] as String?,
      id: json['id'] as String?,
      video: json['video'] as String?,
      youtubeVideoId: json['youtubeVideoId'] as String?,
      assessment: json['assessment'] as bool?,
    );
  }
}

class Word {
  final String? id;
  final String? name;
  final String? video;
  final String? youtubeVideoId;
  final String? image;
  final String? color;
  final List<String> sentenceMaking;
  final bool? sentenceOnly;
  final bool? wordsOnly;

  Word({
    this.id,
    this.name,
    this.video,
    this.youtubeVideoId,
    this.image,
    this.color,
    this.sentenceMaking = const [],
    this.sentenceOnly,
    this.wordsOnly,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'] as String?,
      name: json['name'] as String?,
      video: json['video'] as String?,
      youtubeVideoId: json['youtubeVideoId'] as String?,
      image: json['image'] as String?,
      color: json['color'] as String?,
      sentenceMaking: (json['sentenceMaking'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      sentenceOnly: json['sentenceOnly'] as bool?,
      wordsOnly: json['wordsOnly'] as bool?,
    );
  }
}

class Sentence {
  final String? id;
  final String? sentence;
  final List<String> wordArray;
  final String? video;
  final String? youtubeVideoId;

  Sentence({
    this.id,
    this.sentence,
    this.wordArray = const [],
    this.video,
    this.youtubeVideoId,
  });

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      id: json['id'] as String?,
      sentence: json['sentence'] as String?,
      wordArray: (json['wordArray'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      video: json['video'] as String?,
      youtubeVideoId: json['youtubeVideoId'] as String?,
    );
  }
}

class Activity {
  final String? name;
  final String? id;
  final List<Word> words;
  final List<Sentence> sentences;

  Activity({
    this.name,
    this.id,
    this.words = const [],
    this.sentences = const [],
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      name: json['name'] as String?,
      id: json['id'] as String?,
      words: (json['words'] as List?)
              ?.map((e) => Word.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sentences: (json['sentences'] as List?)
              ?.map((e) => Sentence.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}