class HomeworkNotifier < ActionMailer::Base
  default from: "课程网站<from@example.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.homework_notifier.commited.subject
  #
  def commited(homework)
    @homework = homework.quziId
    @user = homework.student.user

    mail to: @user.email, subject: 'Homework Commited Confirmation'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.homework_notifier.commented.subject
  #
  def commented(homework)
    @homework = homework.quziId
    @user = homework.student.user

    mail to: @user.email, subject: 'Homework Commented Confirmation'
  end
end
