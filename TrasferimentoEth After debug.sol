// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.2;

contract TrasferimentoEth {           

//Variabili di stato
    
    //parti
    address Tizio;      //committente
    address Caio;       //prestatore d'opera 

    //Indicatori di tempo
    uint DataDeploy;    //Data deploy dello smart contract 
    uint MeseUno;       //esigibilità primo pagamento
    uint MeseDue;       //esigibilità secondo pagamento
    uint MeseTre;       //esigibilità terzo pagamento
    
    //Database delle operazioni
    mapping(uint=>bool) Riscosso;       // "true" indica che la rata è già stata riscossa 
    mapping(uint=>bool) PagamentoBloccato; //"true" quando il committente blocca l'esecuzione della prestazione di pagamento
    
    //Dati 
    string Motivazione;                 //motivazione fornita da Tizio all'interruzione del pagamento


    constructor() payable{              //payable= il contratto puo' ricevere Ether
        
        //definiamo le parti
        Tizio = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
        Caio  = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

        //definiamo le variabili cronologiche
        DataDeploy = block.timestamp;   //la variabile assumerà il timestamp del momento in cui avviene il DataDeploy
        MeseUno= DataDeploy + 10 seconds;  //data esigibilità primo pagamento, 10 giorni dal deploy;
        MeseDue= MeseUno + 30 seconds;     //data esigibilità secondo pagamento, 40 giorni dal deploy;
        MeseTre= MeseDue + 30 seconds;     //data esigibilità terzo pagamento, 70 giorni dal deploy;
    }
    
    /*Definizione delle funzioni, in ordine di scrittura:
        - Una funzione per inviare Ether al contratto;
        - Una funzione per leggere il bilancio dello SC.
        - Tre funzioni per la riscossione delle rate a favore di Caio;
        - Una funzione ad uso esclusivo di Tizio, per interrompere l'esecuzione del pagamento
            e ottenere la restituzione dell'importo restante all'interno dello SC;
    */
    
    //function per inviare Ether allo SC
    function TraferisciEtherAlloSC() external payable {          //1 wei = 10^(-18) ether.
    }
    
    //function per conoscere il bilancio dello SC.
    function BilancioSC() external view returns(uint){          
        return address(this).balance;
    }    
    
    function PagamentoPrimaRata () external {      //funzione per riscuotere il pagamento relativo alla prima rata.
        require(Riscosso[MeseUno]==false, "Mensilita' gia' riscossa");
        require(PagamentoBloccato[MeseUno]==false, "il pagamento e' stato bloccato da Tizio");
        require(block.timestamp >= MeseUno, "troppo presto per riscuotere");
        
        payable(Caio).transfer(3000000000000000000);   //traferisci a Caio 3 Ether 
        Riscosso[MeseUno]=true;                            //aggiorna database
    }
    
    function PagamentoSecondaRata() external {      //funzione per riscuotere il pagamento relativo alla seconda rata.
        require(Riscosso[MeseDue]==false, "Mensilita' gia' riscossa");
        require(PagamentoBloccato[MeseUno]==false && PagamentoBloccato[MeseDue]==false, "il pagamento e' stato bloccato da Tizio");
        require(block.timestamp >= MeseDue, "troppo presto per riscuotere");
        
        payable(Caio).transfer(3000000000000000000);   // Pagamento 3 Ether   
        Riscosso[MeseDue]=true;
    }

    function PagamentoTerzaRata () external {      //funzione per riscuotere il pagamento relativo alla terza rata.
        require(Riscosso[MeseTre]==false, "Mensilita' gia' riscossa");
        require(PagamentoBloccato[MeseUno]==false && PagamentoBloccato[MeseDue]==false
            && PagamentoBloccato[MeseTre]==false, "il pagamento e' stato bloccato da Tizio");
        require(block.timestamp >= MeseTre, "troppo presto per riscoutere");
        
        payable(Caio).transfer(3000000000000000000);   // Pagamento 3 Ether  
        Riscosso[MeseTre]=true;
    }    
    
    //una function ad uso esclusivo di Tizio che permette l'interruzione della prestazione di pagamento.
    function BloccaPagamentoRata(string memory _motivazione) external returns(string memory){    
        require(msg.sender==Tizio, "Non sei Tizio");
        if (PagamentoBloccato[MeseUno]==false && block.timestamp < MeseUno)
            {PagamentoBloccato[MeseUno]=true;
             payable(Tizio).transfer(9000000000000000000);}
               
        else if (PagamentoBloccato[MeseDue]==false && block.timestamp > MeseUno 
            && block.timestamp < MeseDue)
            {PagamentoBloccato[MeseDue]=true;
            payable(Tizio).transfer(6000000000000000000); }
       
        else if (PagamentoBloccato[MeseTre]==false && block.timestamp > MeseDue 
            && block.timestamp < MeseTre)
            {PagamentoBloccato[MeseTre]=true;
            payable(Tizio).transfer(3000000000000000000);}
       
        else revert("il pagamento e' gia' stato bloccato o non ci sono le condizioni per bloccare il pagamento");
          
        //RIMUOVI payable(Tizio).transfer(address(this).balance);    //restituisce gli Ether rimanenti ad Tizio, N.B. altrimenti imprigionati.
        Motivazione = _motivazione;                         
        return Motivazione;                                //restituisci la motivazione fornita da Tizio
    }

}