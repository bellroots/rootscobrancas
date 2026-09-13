export const brl = v => Number(v||0).toLocaleString('pt-BR',{style:'currency',currency:'BRL'});
export const dateBR = d => d ? new Date(`${d}T00:00:00`).toLocaleDateString('pt-BR') : '-';
export function calcParcelas({valor,taxa,qtd,dataInicio,sistema}){
  valor=Number(valor); taxa=Number(taxa)/100; qtd=Number(qtd);
  let valorParcela;
  if(sistema==='juros_simples') valorParcela=(valor+(valor*taxa*qtd))/qtd;
  else if(taxa===0) valorParcela=valor/qtd;
  else valorParcela=valor*(taxa*Math.pow(1+taxa,qtd))/(Math.pow(1+taxa,qtd)-1);
  valorParcela=Math.round(valorParcela*100)/100;
  const base=new Date(`${dataInicio}T00:00:00`);
  const parcelas=Array.from({length:qtd},(_,i)=>{ const d=new Date(base); d.setMonth(d.getMonth()+i); return {numero:i+1,data_vencimento:d.toISOString().slice(0,10),valor_original:valorParcela,valor_pago:0,status:'a_vencer'}; });
  return {valorParcela,parcelas};
}
export function encargos(emp,p){
  const hoje=new Date(); hoje.setHours(0,0,0,0); const venc=new Date(`${p.data_vencimento}T00:00:00`);
  const base=Math.max(0,Number(p.valor_original)-Number(p.valor_pago||0)); const dias=Math.floor((hoje-venc)/86400000);
  if(p.status==='paga'||dias<=0||base<=0) return {dias:0,mora:0,multa:0,total:base,atrasada:false};
  const taxa=Number(emp.taxa_juros_mora||0)/100;
  const mora=taxa ? base*taxa*(emp.tipo_mora==='diaria'?dias:dias/30) : 0;
  const mv=Number(emp.multa_atraso_valor||0); const multa=mv ? (emp.multa_atraso_tipo==='fixo'?mv:base*(mv/100)) : 0;
  return {dias,mora,multa,total:base+mora+multa,atrasada:true};
}
