#!/bin/bash

# Список пакетов
packages=("curl" "git" "vim" "nonexistent-package")  # пример

# Файл лога
log_file="failed_packages.log"

# Очищаем предыдущий лог
> "$log_file"

# Проходим по каждому пакету
for pkg in "${packages[@]}"; do
    echo "Попытка установить $pkg..."
    if sudo apt install -y "$pkg"; then
        echo "$pkg установлен успешно."
    else
        echo "$pkg не удалось установить, записываем в лог."
        echo "$pkg" >> "$log_file"
    fi
done

# Если есть неустановленные пакеты, выводим сообщение
if [ -s "$log_file" ]; then
    echo "Следующие пакеты не удалось установить. Проверьте $log_file"
fi

