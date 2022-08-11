import 'package:imhotep/models/contest_badge_model.dart';
import 'package:imhotep/models/contest_model.dart';
import 'package:imhotep/models/contest_question_model.dart';
import 'package:peaman/peaman.dart';

class ContestProvider {
  static final _ref = Peaman.ref;

  // create contest
  static Future<void> createContest({
    required final Contest contest,
    required final List<ContestQuestion> questions,
    final Function(Contest)? onSuccess,
    final Function(dynamic)? onError,
  }) async {
    try {
      // create contest document
      final _contestRef = _ref.collection('contests').doc();
      final _contest = contest.copyWith(
        id: _contestRef.id,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      await _contestRef.set(_contest.toJson());
      //

      // add questions to contest
      final _questionsRef = _contestRef.collection('questions');
      final _questionsFutures = <Future>[];

      questions.forEach((e) {
        final _questionRef = _questionsRef.doc();
        final _question = e.copyWith(id: _questionRef.id);
        final _questionFuture = _questionRef.set(_question.toJson());
        _questionsFutures.add(_questionFuture);
      });
      await Future.wait(_questionsFutures);
      //

      print('Success: Creating contest');
      onSuccess?.call(_contest);
    } catch (e) {
      print(e);
      print('Error!!!: Creating contest');
      onError?.call(e);
    }
  }

  // update contest
  static Future<void> updateContest({
    required final String contestId,
    required final Map<String, dynamic> data,
    final Function(String)? onSuccess,
    final Function(dynamic)? onError,
  }) async {
    try {
      final _contestRef = _ref.collection('contest').doc(contestId);
      await _contestRef.update(data);
      print('Success: Updating contest $contestId');
      onSuccess?.call(contestId);
    } catch (e) {
      print(e);
      print('Error!!!: Updating contest');
    }
  }

  // delete contest
  static Future<void> deleteContest({
    required final String contestId,
    final Function(String)? onSuccess,
    final Function(dynamic)? onError,
  }) async {
    try {
      final _contestRef = _ref.collection('contests').doc(contestId);
      await _contestRef.delete();
      print('Success: Deleting contest $contestId');
      onSuccess?.call(contestId);
    } catch (e) {
      print(e);
      print('Error!!!: Deleting contest');
      onError?.call(e);
    }
  }

  // update contest question
  static Future<void> updateContestQuestion({
    required final String contestId,
    required final String questionId,
    required final Map<String, dynamic> data,
    final Function(String)? onSuccess,
    final Function(dynamic)? onError,
  }) async {
    try {
      final _contestRef = _ref.collection('contest').doc(contestId);
      final _questionRef = _contestRef.collection('questions').doc(questionId);

      await _questionRef.update(data);
      print('Success: Updating contest question $questionId');
      onSuccess?.call(contestId);
    } catch (e) {
      print(e);
      print('Error!!!: Updating contest question');
    }
  }

  // delete contest question
  static Future<void> deleteContestQuestion({
    required final String contestId,
    required final String questionId,
    final Function(String)? onSuccess,
    final Function(dynamic)? onError,
  }) async {
    try {
      final _contestRef = _ref.collection('contest').doc(contestId);
      final _questionRef = _contestRef.collection('questions').doc(questionId);

      await _questionRef.delete();
      print('Success: Deleting contest question $questionId');
      onSuccess?.call(contestId);
    } catch (e) {
      print(e);
      print('Error!!!: Deleting contest question');
    }
  }

  // add badge
  static Future<void> addBadge({
    required final ContestBadge contestBadge,
  }) async {
    try {
      final _contestBadgeRef =
          _ref.collection('contest_badges').doc(contestBadge.ownerId);
      final _contestBadge = contestBadge.copyWith(
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      await _contestBadgeRef.set(_contestBadge.toJson());
      print('Success: Adding badge to user ${contestBadge.ownerId}');
    } catch (e) {
      print(e);
      print('Error!!!: Adding badge to user');
    }
  }

  // list of contests from database
  static List<Contest> _contestsFromDatabase(dynamic querySnap) {
    return List<Contest>.from(
      querySnap.docs.map((e) => Contest.fromJson(e.data() ?? {})).toList(),
    );
  }

  // list of contest questions from database
  static List<ContestQuestion> _contestQuestionsFromDatabase(
    dynamic querySnap,
  ) {
    return List<ContestQuestion>.from(
      querySnap.docs
          .map((e) => ContestQuestion.fromJson(e.data() ?? {}))
          .toList(),
    );
  }

  // contest badge from firestore
  static ContestBadge _contestBadgeFromFirestore(dynamic snap) {
    return ContestBadge.fromJson(snap.data() ?? {});
  }

  // stream of list of contests
  static Stream<List<Contest>> get contests {
    return _ref
        .collection('contests')
        .orderBy('starts_at')
        .snapshots()
        .map(_contestsFromDatabase);
  }

  // stream of list of contest questions
  static Stream<List<ContestQuestion>> contestQuestionsByContestId({
    required final String contestId,
  }) {
    return _ref
        .collection('contests')
        .doc(contestId)
        .collection('questions')
        .snapshots()
        .map(_contestQuestionsFromDatabase);
  }

  // stream of contest badge
  static Stream<ContestBadge> contestBadge({
    required final String ownerId,
  }) {
    return _ref
        .collection('contest_badges')
        .doc(ownerId)
        .snapshots()
        .map(_contestBadgeFromFirestore);
  }
}
