package controller.commands
{
	import model.proxy.LessonPlanProxy;
	import model.valueObjects.T_lesson;
	import model.valueObjects.T_lesson_plan_item;
	import model.valueObjects.T_user;
	
	import mx.controls.Alert;
	import mx.events.DragEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import views.components.ApplicationView;
	import views.components.LessonPlanItem;
	import views.mediators.ApplicationMediator;
	import views.mediators.VirtualMusicLessonsMediator;
	
	/**
	 * @author Francois Dubois
	 * Dieser Command löst das Erstellen eines LessonPlanItems auf der MySQL Tabelle TlessonPlanItem aus
	 * */
	public class CreateLessonPlanItemCommand extends SimpleCommand
	{
		override public function execute(note: INotification) :void	
		{

			var lessonPlanItemUI:LessonPlanItem = note.getBody() as LessonPlanItem;
			var lessonPlanItem:T_lesson_plan_item = new T_lesson_plan_item;		
			var app:VirtualMusicLessonsMediator = (facade.retrieveMediator(VirtualMusicLessonsMediator.NAME) as VirtualMusicLessonsMediator);
			
			lessonPlanItem.t_lesson_plan_item_id = 0;
			lessonPlanItem.lesson_id = lessonPlanItemUI.getLessonData().P_Lesson_ID;
			lessonPlanItem.user_id = (app.getHoldedUserData() as T_user).P_User_ID;
			
			lessonPlanItem.display_index = lessonPlanItemUI.getLessonPlanDisplayIndex();
			
			lessonPlanItem.x_position = lessonPlanItemUI.x;
			lessonPlanItem.y_position = lessonPlanItemUI.y;
			
			
			( facade.retrieveProxy(LessonPlanProxy.NAME) as LessonPlanProxy ).createLessonPlanItem(lessonPlanItem);
			
		}
	}
}