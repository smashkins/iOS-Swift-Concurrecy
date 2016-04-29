# Threads

Un *thread* è semplicemente un sottoprocesso della tua app che può essere eseguito anche mentre altri processi sono in esecuzione.
Questa esecuzione simultanea è chiamata *concurrency*.

Il Framework iOS fa uso dei threads continuamente, se non lo facesse la nostra app risulterebbe meno responsive all'utente o a volte completamente non responsive.

Quando per esempio la nostra app scarica qualcosa da internet, il download non avviene tutto insieme ma in qualche posto *qualcuno* sta procedendo con il nostro codice per interagire con la rete ed ottenere dei dati.

# Main Thread

Quando il codice chiama un metodo, quel metodo normalmente gira sullo stesso thread della chiamata. Il nostro codice è chiamato attraverso degli eventi generati da **Cocoa**; questi eventi chiamano normlmamente il nostro codice sul **main thread**.

**Il main thread è il thread dell'interfaccia**. Quando un utente interagisce con l'interfaccia, queste interazioni sono riportate come degli *eventi sul main thread*.

Quando il nostro codice interagisce con l'interfaccia **deve** farlo sul main thread.
Naturalmente ciò accade automaticamente in quanto il nostro codice gira sul main thread.

I frameworks operano in threads secondari tutto il tempo. Il fatto che tu non te ne accorga è dovuto al fatto che normalmente i framework dialogano con il tuo codice sul main thread.
Esempi del genere sono:

- Durante un animazione l'interfaccia rimane responsive all'utente, infatti il Core Animation framework fa girare l'animazione e aggiorna il presentation layer su un thread in background. Ma i metodi delegate o i completion blocks sono chiamati sul thread principale.

- Le web view carincano i loro contenuti in maniera asincrona in threads di background.

		Moving time-consuming code off the main thread,
		so that the main thread is not blocked, 
		isn’t just a matter of aesthetics or politeness: 
		the system “watchdog” will summarily kill your app
		if it discovers that the main thread is blocked for too long.
		

# NSOperation e NSOperationQueue

l’oggetto NSOperation è disegnato per essere esteso ed implementare l’insieme di azioni che vanno eseguite in un threading; queste azioni vanno posizionate all’interno del metodo – (void) main {}. Il modo più facile per usare un oggetto NSOperation è quello di farlo eseguire da NSOperationQueue, che come è possibile intuire dal nome permette di mantenere una coda di azioni (oggetti NSOperation) che potranno essere anche esauriti in parallelo

NSOperationQueue si occuperà di gestire la coda in maniera intelligente distribuendo al meglio il carico sull’hardware che c’è a disposizione


