# GDG (Grand Central Dispatch)

è una tecnologia sviluppata da Apple Inc. per ottimizzare l'esecuzione delle applicazioni su sistemi multi core o su altri sistema basati sul multiprocessing simmetrico. Questa implementa un parallelismo a livello di thread seguendo il thread pool pattern.

GCD lavora consentendo al programmatore di delimitare specifiche porzioni di codice che possono essere eseguite in parallelo definendole come blocchi.

Seguendo il pattern thread pool durante l'esecuzione del programma i blocchi vengono messi in una coda e vengono eseguiti appena una unità di elaborazione si rende disponibile

GCD per eseguire i blocchi utilizza i thread ma al programmatore la cosa è totalmente trasparente. Questo permette al programmatore di concentrasi sullo sviluppo degli algoritmi disinteressandosi della gestione del thread e della loro sincronizzazione. La creazione dei blocchi è un'operazione semplice e veloce dato che può essere svolta con sole 15 istruzioni, mentre la creazione di un thread senza l'utilizzo di GCD richiede centinaia di istruzioni

Un blocco creato con GCD può essere utilizzato per creare un'attività da mettere in una coda d'esecuzione o può essere assegnato a una sorgente di eventi. Se un blocco è assegnato a una sorgente d'eventi quando si verifica l'evento il blocco viene attivato e messo in una coda d'esecuzione. Questa modalità di funzionamento è definita da Apple come più efficiente rispetto alla creazione di un thread che deve attendere il verificarsi di un evento.

# Caratteristiche
--
- Le Dispatch Queues sono delle code che contengono dei blocchi di codice o delle funzioni che vengono eseguite. La libreria automaticamente crea diverse code con diversi livelli di priorità ed esegue diversi task concorrenti selezionando il numero ottimale di task da eseguire a seconda delle condizioni operative del momento. Un utilizzatore della libreria può creare quante code seriali vuole, in una coda seriale i task vengono eseguiti in modo seriale e quindi l'esecuzione di un blocco è critico per l'esecuzione di ogni altro blocco della coda e quindi le code seriali possono essere utilizzate per gestire risorse condivise al posto di altre strutture come i lock.

- Le Dispatch Sources sono degli oggetti sui quali possono essere registrati dei blocchi di codice che verranno eseguiti nel caso si scateni un evento come la creazione di un file o l'attivazione di un evento POSIX.

- I Dispatch Groups sono degli oggetti che raggruppano più blocchi. I blocchi sono aggiunti al gruppo e l'utilizzatore può utilizzare i dati elaborati quando tutti i blocchi sono stati eseguiti.

- I Dispatch Semaphores sono degli oggetti che permettono all'utilizzatore della libreria di limitare l'esecuzione parallela solo ad alcuni blocchi.

--
A most regular use of GCD in Swift is like this (which I guess covering half of GCD using daily work):

	// Create a queue
	let workingQueue = dispatch_queue_create("my_queue", nil)

	// Dispatch to the newly created queue. GCD take the responsibility for most things.
	dispatch_async(workingQueue) {
    	// Async work in workingQueue
    	print("Working...")
    	NSThread.sleepForTimeInterval(2)  // Simulate for 2 secs executing time

    	dispatch_async(dispatch_get_main_queue()) {
        	// Return to main queue, update UI here
        	print("Work done. Update UI")
    	}
	}
	
UIKIT effettua il suo lavoro sul mainThread principale quindi se abbiamo dei work che agiscono sul main thread (ma che non fanno parte dell'interfaccia la quale deve agire sempre sul main Thread) che appesantiscono il programma è conveniente utilizzare quel work in un processo in background.

Un miglioramento al GDC introdotto su iOS 8 è che adesso i processi in background possono essere cancellati.
E' stato aggiunto un type di blocco *dispatch_block_t* tramite il quale possiamo cancellare un blocco schedulato