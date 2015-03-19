package 
{
	import away3d.materials.PhongBitmapMaterial;
	import away3d.materials.BitmapMaterial;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.math.MatrixAway3D;
	import away3d.primitives.Sphere;
	import away3d.lights.DirectionalLight3D;
	import away3d.core.math.Number3D;
	import away3d.materials.PhongColorMaterial;
	import away3d.materials.ShadingColorMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.materials.EnviroColorMaterial;
	import away3d.core.utils.Cast;
	import com.serialization.json.JSON;
	
	import Detail;
	
	/**
	 * Главный спрайт отображалки
	 * @author Евгений Малашкин
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * Загружает 3D-объект согласно описанию.
		 * 
		 * objectDefinition - {geometry: <URL файла с геометрией>, texMap: <URL файла с текстурой>}
		 * 
		 * @param	objectDefinition	описание объекта
		 */
		public function loadObject(objectDefinition:Object):void
		{
		}
		
		private var m_view:View3D;
		private var m_scene:Scene3D;
		private var m_objectContainer:ObjectContainer3D;
		private var m_rotating:Boolean = false;
		private var m_lastMouseX:Number = 0;
		private var m_lastMouseY:Number = 0;		
		private var m_rotateXMatrix:MatrixAway3D = new MatrixAway3D();
		private var m_rotateYMatrix:MatrixAway3D = new MatrixAway3D();
		private var m_rotateMatrix:MatrixAway3D = new MatrixAway3D();
		private var m_rotateXMatrixAlngle:Number = 0;
		private var m_rotateYMatrixAlngle:Number = 0;
		
		[Embed(source = "../assets/j.txt", mimeType = "application/octet-stream")]
		private var JsonClass:Class;
		
		[Embed (source="../assets/tex1.png")]
		private var TextureClass1:Class;		
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initExternalInterface();
			initView3D();
		}
		
		private function initExternalInterface():void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("loadObject", loadObject);
			}
		}
		
		private function initView3D():void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			m_view = new View3D;
			addChild(m_view);			   
			m_view.x = stage.stageWidth / 2;
			m_view.y = stage.stageHeight / 2;
			
			m_scene = new Scene3D;
			m_view.scene = m_scene;
			//m_view.camera.focus = 10000000;
			//m_view.camera.zoom = 400;
			
			m_objectContainer = new ObjectContainer3D();
			
			
			var byteArray:ByteArray = new JsonClass(  );
			var st:String = byteArray.readUTFBytes(byteArray.length);
			//trace(st);
			var o:Object = JSON.deserialize(st);
			var a:Array = o as Array;
			trace(o.length);
			
			var d:Detail = new Detail;
			d.build(o[0]);
			var m:PhongColorMaterial = new PhongColorMaterial(0xFF0000);
			var m3:PhongBitmapMaterial = new PhongBitmapMaterial(Cast.bitmap(new TextureClass1));
			
			d.material = m3;
			
			
			//m_objectContainer.addChild(new Sphere);
			m_objectContainer.addChild(d);
			
			m_scene.addChild(m_objectContainer);
			
			var light:DirectionalLight3D=new DirectionalLight3D;
			light.direction = new Number3D(0, 1, 500);
			light.color = 0xFFFFFF;
			light.ambient = 0.4;
			light.diffuse = 0.4;
			light.specular = 0.4;
			m_scene.addLight(light);
			
			m_view.render();
			m_view.render();
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			m_rotating = true;
			m_lastMouseX = event.stageX;
			m_lastMouseY = event.stageY;
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			if (m_rotating)
			{
				m_rotateYMatrixAlngle -= (event.stageX - m_lastMouseX) / 50;
				m_rotateXMatrixAlngle -= (event.stageY - m_lastMouseY) / 50;
				m_rotateXMatrix.rotationMatrix(1, 0, 0, m_rotateXMatrixAlngle);
				m_rotateYMatrix.rotationMatrix(0, 1, 0, m_rotateYMatrixAlngle);
				m_rotateMatrix.multiply(m_rotateXMatrix, m_rotateYMatrix);
				m_objectContainer.transform = m_rotateMatrix;
				m_view.render();
				m_lastMouseX = event.stageX;
				m_lastMouseY = event.stageY;
			}
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			m_rotating = false;
		}
		
	}
	
}