#encoding:utf-8

#TODO pegar a linha que possui o as e descobrir o nome do campo
#pegar o nome dos fields usados que possuam o #P{campo}
puts "Digite o nome do arquivo"

diretorio_relatorios = "/home/gabriel/projects/ieducar/ieducar-utils/reports/jasperreports/"

nome_arquivo = gets.chomp


f = File.open(diretorio_relatorios + nome_arquivo, 'r')

campos_sql = []

f.each do |f|
  if f.match(/\b#{"as "}\b/i)
    campo = ""
    index = f.upcase.index("AS ")
    index += 3
    for index in index..f.length - 1
      campo += f[index]
    end
    campo.chomp!
    campo.sub!(/,/, "")
    campos_sql << campo
  end
end

campos_ireport = []

f = File.open(diretorio_relatorios + nome_arquivo, 'r')

f.each do |linha|
   campo_ireport = []
   campos = linha.scan(/\$F\{[\w]*\}/)
   campos.each do |campo|
    campo.sub! "$F{", ""
    campo.sub! "}", ""
    campo.sub! "[", ""
    campo.sub! "]", ""
    campo_ireport << campo
   end

   campos_ireport << campo_ireport
end

campos_ireport.flatten!
campos_ireport.reject! { |c| c.empty? }

campos_ireport.map {|ci| ci.upcase! }
campos_sql.map {|cs| cs.upcase! }

puts campos_sql.inspect
puts campos_ireport.inspect

puts "Campos que podem ser removidos do SQL: "

campos_sql.each do |campo|
  puts campo unless campos_ireport.include?(campo)
end