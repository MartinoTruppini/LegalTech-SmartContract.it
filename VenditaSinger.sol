// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.7.4;

contract VenditaSinger{
    
    /* Questo smart contract definisce un contratto di compravendita */
  
    
    //identità delle parti che stipulano il contratto
    address private Tizio;
    address private Caio;
    string private IdCaio;
    string private IdTizio;
    
    //premesse
    string private Premesse;
    
    //testo del contratto
    string private TestoContratto;

    //Firme
    bool private FirmaTizio;
    bool private FirmaCaio;
    
    //Utilizziamo il costruttore per inserire i dati della scrittura privata
    constructor () {
        //Definizione dei dati delle parti
        IdTizio="Sig. Tizio nato a... il... e residente in..., C.F. ..., in qualita' di VENDITORE";
        Tizio=0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
        
        IdCaio="Sig. Caio nato a... il... e residente in..., C.F. ..., in qualita' di ACQUIRENTE";
        Caio =0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
        
        //testo della scrittura privata
        Premesse=" PREMESSO CHE: (I) - il sig. Tizio e' proprietario di una macchina da cucire Singer del 1905, "
                "(II) - la macchina da cucire ha vernice originale e non e' mai stata restaurata, "    
                "(III) - il prezzo concordato per la macchina da cucire e' di euro 650,00.";
        TestoContratto = " TUTTO CIO' PREMESSO: Art. 1 - Il sig. Tizio dichiara di trasferire ai sensi dell'art.1470 c.c. "
                "la macchina da cucire, di cui al punto (I) delle premesse, al sig. Caio che "
                "accetta la proprieta' del bene verso corrispettivo di cui al punto (III) delle premesse."
                "Art. 2 - Il sig. Caio paga il prezzo di cui al punto (III) delle premesse al sig. Tizio "
                "il quale rilascia la quietanza di pagamento con la presente scrittura privata."
                "Art. 3 - Il sig. Caio dichiara di ricevere il bene di cui al punto (I) delle premesse "
                "con la sottoscrizione della presente scrittura privata. ";
    } 
    
    //Elenco Funzioni
        /* Lo smart contract contiene le seguenti funzioni:
        -lettura testo del contratto (lettura);
        -lettura identità delle parti(lettura);
        -Sottoscrizione dell'accordo  (scrittura);
        -Verifica sottoscrizione (lettura);
        */
    
    //Lettura testo del Testo del Contratto
    function LeggiTestoContratto() public view returns (string memory, string memory) {
        return (Premesse, TestoContratto);
    }
    //Lettura identità delle parti
    function GeneralitaParti() public view returns (string memory, string memory) {
        require (msg.sender==0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 || 
            msg.sender==0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, "Non sei parte del contratto");
        return(IdTizio, IdCaio);
    } 
    //Sottoscrivere
    function Firma() public {
        require (msg.sender==Tizio || 
            msg.sender==Caio, "Non sei parte del contratto");
        if(msg.sender==Tizio)
            FirmaTizio=true; 
        if(msg.sender==Caio)
            FirmaCaio=true;
    }    
    
    //Verifica Sottoscrizioni
    function VerificaSottoscrizione() public view returns  (bool, bool){
        return (FirmaTizio,FirmaCaio);
    }    
}
