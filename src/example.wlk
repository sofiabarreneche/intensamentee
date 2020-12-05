object riley{
	var property nivelFelicidad = 1000
	var emocionDominante 
	var property pensamientosCentrales = #{}
	var property recuerdosDelDia = #{}
	var property memoriaLargoPlazo = #{}
	var edad
	const fechaNacimiento = new Date(day= 3, month = 6, year= 1997)
	method calcularEdad(){
		const fechaActual = new Date()
		edad = fechaActual.year() - fechaNacimiento.year()
	}
	method rememorar(){
		const rec = memoriaLargoPlazo.anyOne()
		if(rec.anios()>edad/2)
			recuerdosDelDia.add(rec)
	}
	method repeticionesEnMemoria(recuerdo) = memoriaLargoPlazo.occurrencesOf(recuerdo)
	
	method dejaVu(){
		recuerdosDelDia.any({rec=>rec.repetidoEnMemoria()})
	}
	method dormir(){
		const dormir = new ProcesoMental(procesos = [asentamiento,asentamientoSelectivo,profundizacion,
			controlHormonal,restauracionCognitiva, liberacionRecuerdosDia]) 
	}
	method controlHormonal(){
		if(self.pensCentralEnLargoPlazo() or self.recuerdosDiaMismaEmocion()){
		self.desequilibrioHormonal()	
		}
	}
	method asentarSelectivamente(palabra,recuerdo){
		recuerdo.asentarSelectivo(palabra)
		
		}
	method liberarRecuerdosDia(){
		recuerdosDelDia.clear()
	}
	method pensCentralEnLargoPlazo() = pensamientosCentrales.any({pens=>memoriaLargoPlazo.contains(pens)})
	method recuerdosDiaMismaEmocion() = recuerdosDelDia.all({recu=>recu.emocion() == emocionDominante})
	method desequilibrioHormonal(){
		self.disminuirFelicidad(15)
		self.perderRecuerdosCentrales(3)
	}
	method restaurarFelicidad(){
		nivelFelicidad = (nivelFelicidad += 100).min(1000)
	}
	method perderRecuerdosCentrales(cant){
		pensamientosCentrales.asList().drop(cant)
	}
	method vivirUnMomento(descrip){
		const recuerdo = new Recuerdo(descripcion = descrip, fecha = new Date(), emocion = emocionDominante)
	}
	method negarRecuerdo(recuerdo){
		recuerdo.negarse()
	}
	method asentarRecuerdo(recuerdo){
		recuerdo.asentarse()
	}
	method agregarPensamientoCentral(recuerdo){
		pensamientosCentrales.add(recuerdo)
	}
	method disminuirFelicidad(porcentaje){
		nivelFelicidad-=nivelFelicidad*porcentaje/100
		if(nivelFelicidad<1)
			self.error("La felicidad no puede ser menor a 1")
	}
	method conocerRecuerdosRecientes(){
		recuerdosDelDia.reverse().take(5)
	}
	method conocerPensamientosCentrales(){
		pensamientosCentrales.take(pensamientosCentrales.size())
	}
	method pensamientoDificilDeExplicar(recuerdo){
		recuerdo.esDificilDeExplicar()
	}
	method pensamientosCentralesDificiles(){
		pensamientosCentrales.filter({unRecuerdo => unRecuerdo.esDificilDeExplicar()})
	}
}

class ProcesoMental{
	var procesos 
}
object asentamiento{
	method realizarProceso(recuerdo){
		riley.asentarRecuerdo(recuerdo)
		}
}
object asentamientoSelectivo{
	var palabra
	method realizarProceso(recuerdo){
		riley.asentarSelectivamente(palabra,recuerdo)
	}
}
object profundizacion{
	method realizarProceso(recuerdo){
		riley.recuerdosDelDia().filter({unRecu => unRecu.noEsCentral()})
		riley.recuerdosDelDia().filter({unRecu => unRecu.noNegado()})
	}
}
object controlHormonal{
	method realizarProceso(recuerdo){
		riley.controlHormonal()
	}
}
object restauracionCognitiva{
	method realizarProceso(recuerdo){
		riley.restaurarFelicidad()
	}
}
object liberacionRecuerdosDia{
	method realizarProceso(recuerdo){
		riley.liberarRecuerdosDia()
	}
}
class Recuerdo{
	var descripcion
	var fecha
	var property emocion
	method noNegado() = !emocion.negar(self)
	method noEsCentral() = !riley.pensamientosCentrales().contains(self)
	method negarse(){
		emocion.negar(self)
	}
	method repetidoEnMemoria() = riley.repeticionesEnMemoria(self)>1
	method asentarSelectivo(palabra){
		descripcion.words().contains(palabra)	//asi me estaria fijando si en las palabras alguna concuerda con la pasada??
	}
	method asentarse(){
		emocion.cumplirAsentamiento(self)
	}
	method esDificilDeExplicar() = descripcion.words().size() >10
}

class Emocion{
	method cumplirAsentamiento(recuerdo){}
}
object alegre inherits Emocion{
	method negar(recuerdo)= recuerdo.emocion() != self
	override method cumplirAsentamiento(recuerdo){
		if(riley.nivelFelicidad() > 500){
			riley.agregarPensamientoCentral(recuerdo)
		}
	}
}
object triste inherits Emocion{
	method negar(recuerdo) = recuerdo.emocion() == alegre
	override method cumplirAsentamiento(recuerdo){
		riley.agregarPensamientoCentral(recuerdo)
		riley.disminuirFelicidad(10)
	}
}
object disgusto inherits Emocion{
	
}
object furioso inherits Emocion{
	
}
object temeroso inherits Emocion{
	
}

object compuesta inherits Emocion{
	const emociones = []
	
	method negar(recuerdo) = emociones.all({emo=>emo.negar(recuerdo)})
	
	method esAlegre() = emociones.contains(alegre)
	
	override method cumplirAsentamiento(recuerdo){
		emociones.forEach({emo=>emo.cumplirAsentamiento(recuerdo)})
	}
}