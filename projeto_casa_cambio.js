function criarMoeda(nome, sigla, valor){
    return {nome, valor, sigla};
}

let moedas = {
    usd: criarMoeda('Dólar', 'USD', 5.56810),
    eur: criarMoeda('Euro', 'EUR', 6.63457),
    gbp: criarMoeda('Libra', 'GBP', 7.64738),
    jpy: criarMoeda('Iene', 'JPY', 0.05093),
    ars: criarMoeda('Peso', 'ARS', 0.06033),
}

let casa = { taxa = 0.10};

casa.proporCompra = function(moeda, quantidade){
    let valorAjustado = moeda.valor - (moeda.valor * this.taxa);
    return valorAjustado * quantidade;
}

casa.proporVenda = function(moeda, quantidade){
    let valorAjustado = moeda.valor * (1 + this.taxa);
    return valorAjustado * quantidade;
}

casa.proporTroca = function(moeda1, qtde1, moeda2, qtde2){
    let valorCompra = this.proporCompra(moeda1, qtde1);
        valorVenda = this.proporVenda(moeda2, qtde2);
        return valorVenda - valorCompra;
}
casa.criarTabelas(moedas) {
    let tabela = [];

    for(let moeda in moedas){
        let linha = {
        "Moeda": moedas[moeda].nome +'(' + moedas[moeda].sigla + ')',
        "Valor de Venda": this.proporVenda(moedas[moeda], 1,),
        "Valor de Compra": this.proporCompra(moedas[moeda], 1)
    };
    tabela.push(linha);
}
    return tabela;
}
console.table(criarTabela(moedas));