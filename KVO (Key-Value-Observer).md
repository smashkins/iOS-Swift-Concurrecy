# KVO (Key-Value-Observer)

[RIFERIMENTO](http://en.swifter.tips/kvo/)

E' considerato una delle piu' potenti caratteristiche di Cocoa.
E' legato al concetto di **PROPERTY OBSERVER** ma ne differisce in maniera sostanziale.

## PROPERTY OBSERVER
In Swift è possibile *osservare* ed effettuare delle response alla modifica delle proprietà.

Vi sono due tipi di metodi per osservare una proprietà:

- *willSet*
- *didSet*

Aggiungerli ad una proprietà è molto semplice. Inserendo il blocco come sotto, possiamo osservare la proprietà e fare ciò che vogliamo:

	class MyClass {
    var myString: String {
        willSet {
            print("Imposterò myString da \(myString) a \(newValue)")
        }
        
        didSet {
            print("Ho Impostato myString da \(oldValue) a \(myString)")
        }
    }
    
    init() {
        myString = "Strega"
    }
	}

	let foo = MyClass()
	foo.myString = "Mago"

	// Output:
	// Imposterò myString da Strega a Mago
	// Ho Impostato myString da Strega a Mago
	
A questo punto è possibile usare *newValue* e *oldValue* in *willSet* e *didSet* per rappresentare i valori che saranno settati o che sono stati già settati rispettivamente.

Un buon esempio del **property observer** potrebbe essere la validazione dei valori come nell'esempio che segue:

	class MyClass {
		var myString: String {
			//...
			didSet {
				if myString == "Mago"{
                myString = "Pippo"
            }
            print(myString)
          }
      }
      
      init() {
        myString = "Strega"
    }
	}

	let foo = MyClass()
	foo.myString = "Mago"
	
	print(foo.myString)

	// Output:
	// Imposterò myString da Strega a Mago
	// Ho Impostato myString da Strega a Mago
	// Pippo
	// Pippo
	
----
Il KVO non "osserva" le proprietà della classe o dell'istanza corrente ma da la possibilità ad altre classi o istanze di ascoltare i cambiamenti di una specifica proprietà (di una chiave-percorso). Altre instanze agiscono quindi da sottoscrittori, quando la proprietà ascoltata cambia, i sottoscrittori ne ricevono notizia.

KVO rende il codice molto flessibile ad esempio puoi ascoltare il valore del model ed aggiornare la UI e fare altre cose simili con KVO.

E' basato sul concetto del Key-Value Coding (KVC) e sul dynamic dispatching ed è possibile usare il pattern KVO soltanto con sottoclassi di NSObject e marcare la proprietà che vogliamo ascoltare come *dynamic* o il *dynamic dispatch* si perderà.

Per implementare KVO per una sottoclasse NSObject in Swift faremo:

	import UIKit

	class MyClass: NSObject {
    	dynamic var date = NSDate()
	}

	private var myContext = 0


	class ViewController: UIViewController {

    	var myObject: MyClass!
    
    	override func viewDidLoad() {
       		super.viewDidLoad()
        	// Do any additional setup after loading the view, typically from a nib.
        	myObject = MyClass()
        	print("MyClass init. Date: \(myObject.date)")
        	myObject.addObserver(self,
                             forKeyPath: "date",
                             options: .New,
                             context: &myContext)
        
        	let delay = 4.5 * Double(NSEC_PER_SEC)
        	let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        	dispatch_after(time, dispatch_get_main_queue()) {
            
            self.myObject.date = NSDate()
        }
    }

    	override func didReceiveMemoryWarning() {
        	super.didReceiveMemoryWarning()
        	// Dispose of any resources that can be recreated.
    	}
    
    	override func observeValueForKeyPath(keyPath: String?,
    	ofObject object: AnyObject?, change: [String : AnyObject]?, 
    	context: UnsafeMutablePointer<Void>) {
        
      		if context == &myContext {
            print("Date is changed. \(change![NSKeyValueChangeNewKey])")
       		}
    	}

	}
	
Eseguendo questo codice avremo come output:

	MyClass init. Date: 2014-08-23 16:37:20 +0000
	Date is changed. Optional(2014-08-23 16:37:23 +0000)
	
**RICORDA** il nuovo valore è preso da un dictionary. Quindi sarebbe bene essere sicuri che esiste un valore per la chiave specificata *(NSKeyValueChangeNewKey)* effettuando un check sul nil o un guard sul *change*
	
Molto spesso capita di usare dei framework dove vorremmo adottare questo meccanismo ma non abbiamo i permessi per modificare le proprietà per renderle dynamic.
In queste situazioni dovremmo aggiungere una sottoclasse che agisce come layer a usare KVO alla classe di origine in questo modo:

	class MyClass: NSObject {
    var date = NSDate()
	}

		class MyChildClass: MyClass {
    		dynamic override var date: NSDate {
        		get { return super.date }
        		set { super.date = newValue }
    	}
	}
	
Un altro problema è che i tipi in puro Swift non ereditano da NSObject e quindi non è possibile usare KVO. Attualmente non vi è alcun meccanismo simile. Con le **property observer** potremmo creare un alternativa. Con i generics e le closure non è molto complicato creare cose eleganti e utili.

[Observable-Swift](https://github.com/slazyk/Observable-Swift) è una libreria che implementa il pattern KVO in puro swift 