class QuizModel
{
  //variables
  final String id;
  final String question;
  final Map<String, dynamic> options;
  final String answer;
  final String category;
  final String createdBy;
  final String topic;

  //constructor
  QuizModel({
    required this.id,
    required this.question,
    required this.options,
    required this.answer,
    required this.category,
    required this.createdBy,
    required this.topic
  });

  //from MAP firebase => dart object
  factory QuizModel.fromMap(Map<String,dynamic> map , String documentId)
  {
    return QuizModel
    (
      id: documentId,
      question:map['question'] ?? '',
      options: Map<String, dynamic>.from(map['options'] ?? {}),
      answer: map['answer'] ?? '',
      category: map['category'] ?? '',
      createdBy: map['createdBy'] ?? '',
      topic: map['topic'] ?? ''
    );
  }

  // To Map dart object => firebase
  Map<String, dynamic> toMap()
  {
    return
    {
      'question': question,
      'options': options,
      'answer': answer,
      'category': category,
      'createdBy': createdBy,
      'topic': topic
    };
  }
}

