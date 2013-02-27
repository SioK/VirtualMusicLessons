package controller.commands
{
	import model.proxy.LessonPlanProxy;
	import model.valueObjects.T_lesson;
	import model.valueObjects.T_lesson_plan_item;
	import model.valueObjects.T_user;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import views.components.LessonPlanItem;
	import views.mediators.VirtualMusicLessonsMediator;
	
	
	
	/**
	 * @author Francois Dubois
	 * Bei Aufruf dieses Commands wird das übergebene LessonPlanItem mit aktueller Position
	 * auf dem LessonPlan aktualisiert
	 * */
	public class UpdateLessonPlanItemCommand extends SimpleCommand
	{
		override public function execute(note: INotification) :void	
		{
			
			var item:LessonPlanItem = note.getBody() as LessonPlanItem;
			var lessonPlanItem:T_lesson_plan_item = new T_lesson_plan_item;	
			var app:VirtualMusicLessonsMediator = (facade.retrieveMediator(VirtualMusicLessonsMediator.NAME) as VirtualMusicLessonsMediator);
			
			lessonPlanItem.lesson_id = ( item.getLessonData() as T_lesson ).P_Lesson_ID;
			lessonPlanItem.user_id = (app.getHoldedUserData() as T_user).P_User_ID;
			
			lessonPlanItem.display_index = 0;
			
			lessonPlanItem.x_position = item.x;
			lessonPlanItem.y_position = item.y;
			
			lessonPlanItem.t_lesson_plan_item_id = item.getLessonPlanItemID();
			
			( facade.retrieveProxy(LessonPlanProxy.NAME) as LessonPlanProxy ).updateLessonPlanItem(lessonPlanItem);
			
		}
	}
}