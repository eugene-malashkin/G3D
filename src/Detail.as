package  
{
	import away3d.core.base.Face;
	import away3d.core.base.Mesh;
	import away3d.core.base.UV;
	import away3d.core.base.Vertex;
	
	/**
	 * Деталь части устройства
	 * @author Евгений Малашкин
	 */
	public class Detail extends Mesh
	{
		/**
		 * Конструктор
		 */
		public function Detail() 
		{
			super();
		}
		
		/**
		 * Построить деталь по заданной геометрии. geometryObject задаётся в формате {vertexes, texCoords, triangles}.
		 * 
		 * vertexes - список вершин в формате {c, i}. c - количество элементов (вершин), i - координаты вершин, заданные
		 * в виде тройки чисел x, y, z.
		 * texCoords - список координат текстуры (UV) в формате {c, i}. c - количество элементов (координат текстур), i -
		 * координаты текстур, заданные в виде двойки чисел u, v.
		 * triangles - список треугольников в формате {c, i}. c - количество элементов (треугольников), i - треугольники,
		 * заданные в виде шестёрки индексов vertex1Index, vertex2Index, vertex3Index, texCoord1Index, texCoord2Index, 
		 * texCoord3Index.
		 * 
		 * @param	geometryObject	геометрия детали
		 * @return	удалось ли построить деталь
		 */
		public function build(geometryObject:Object):Boolean
		{
			var result:Boolean = false;
			var vertexesObject:Object = geometryObject["vertexes"];
			var texCoordsObject:Object = geometryObject["texCoords"];
			var trianglesObject:Object = geometryObject["triangles"];
			if ((vertexesObject != null) && (texCoordsObject != null) && (trianglesObject))
			{
				result = 
					buildVertexes(vertexesObject) && 
					buildTexCoords(texCoordsObject) && 
					buildTriangles(trianglesObject);
				buildMesh();
			}
			return result;
		}
		
		private var m_vertexes:Array = new Array;
		private var m_texCoords:Array = new Array;
		private var m_faces:Array = new Array;
		
		private function buildVertexes(vertexesObject:Object):Boolean
		{
			var result:Boolean = false;
			var items:Array = parseItems(vertexesObject, 3);
			if (items != null)
			{
				for (var i:int = 0; i < items.length / 3; i++)
				{
					var x:Number = (items[i * 3] as Number)*50;
					var y:Number = (items[i * 3 + 1] as Number)*50;
					var z:Number = -(items[i * 3 + 2] as Number)*50;
					if ((!isNaN(x)) && (!isNaN(y)) && (!isNaN(z)))
					{
						m_vertexes.push(new Vertex(x, y, z));
					}
				}
				result = true;
			}
			return result;
		}
		
		private function buildTexCoords(texCoordsObject:Object):Boolean
		{
			var result:Boolean = false;
			var items:Array = parseItems(texCoordsObject, 2);
			if (items != null)
			{
				for (var i:int = 0; i < items.length / 2; i++)
				{
					var u:Number = (items[i * 2] as Number);
					var v:Number = (items[i * 2 + 1] as Number);
					if ((!isNaN(u)) && (!isNaN(v)))
					{
						m_texCoords.push(new UV(u, v));
					}
				}
				result = true;
			}
			return result;
		}
		
		private function buildTriangles(trianglesObject:Object):Boolean
		{
			var result:Boolean = false;
			var items:Array = parseItems(trianglesObject, 6);
			if (items != null)
			{
				for (var i:int = 0; i < items.length / 6; i++)
				{
					var vertex1Index:int = (items[i * 6] as int);
					var vertex2Index:int = (items[i * 6 + 1] as int);
					var vertex3Index:int = (items[i * 6 + 2] as int);
					var texCoord1Index:int = (items[i * 6 + 3] as int);
					var texCoord2Index:int = (items[i * 6 + 4] as int);
					var texCoord3Index:int = (items[i * 6 + 5] as int);
					if ((isVertexIndexValid(vertex1Index)) && (isVertexIndexValid(vertex2Index)) && (isVertexIndexValid(vertex3Index)) && 
						(isTexCoordIndexValid(texCoord1Index)) && (isTexCoordIndexValid(texCoord2Index)) && (isTexCoordIndexValid(texCoord3Index)))
					{
						m_faces.push(new Face(
										m_vertexes[vertex1Index], m_vertexes[vertex2Index], m_vertexes[vertex3Index],
										null,
										m_texCoords[texCoord1Index], m_texCoords[texCoord2Index], m_texCoords[texCoord3Index]
									));
					}
				}
				result = true;
			}
			return result;
		}
		
		private function buildMesh():void
		{
			for (var i:int = 0; i < m_faces.length; i++)
			{
				addFace(m_faces[i]);
			}
		}
		
		private function parseItems(itemsObject:Object, repetitionFactor:int):Array
		{
			var cObject:Object = itemsObject["c"];
			var iObject:Object = itemsObject["i"];
			if ((cObject != null) && (iObject != null))
			{
				var count:int = (cObject as int);
				var tmpArray:Array = (iObject as Array);
				if ((count > 0) && (tmpArray != null) && ((tmpArray.length / repetitionFactor == count)))
				{
					return tmpArray;
				}
			}
			return null;
		}
		
		private function isVertexIndexValid(vertexIndex:int):Boolean
		{
			return (vertexIndex >= 0) && (vertexIndex < m_vertexes.length);
		}
		
		private function isTexCoordIndexValid(texCoordIndex:int):Boolean
		{
			return (texCoordIndex >= 0) && (texCoordIndex < m_texCoords.length);
		}
		
		
		
	}

}